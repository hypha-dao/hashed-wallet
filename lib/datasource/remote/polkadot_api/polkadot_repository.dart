import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/flutter_js/substrate_service.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/substrate_block.dart';
import 'package:hashed/datasource/remote/model/token_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/balances_repository.dart';
import 'package:hashed/datasource/remote/polkadot_api/recovery_repository.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/utils/result_extension.dart';

PolkadotRepository polkadotRepository = PolkadotRepository();

class PolkadotRepositoryState {
  bool isInitialized = false;
  bool isConnected = false;
}

class PolkadotRepository extends KeyRepository {
  late SubstrateService? _substrateService;

  bool get isInitialized => state.isInitialized;
  bool get isConnected => state.isConnected;

  BalancesRepository get balancesRepository => BalancesRepository(_substrateService!.webView);
  RecoveryRepository get recoveryRepository => RecoveryRepository(_substrateService!.webView);

  PolkadotRepositoryState state = PolkadotRepositoryState();

  void handleConnectState(bool isConnected) {
    final wasConnected = state.isConnected;
    print("PolkadotRepository connection state ${isConnected ? 'Connected' : 'Disconnected'}");
    state.isConnected = isConnected;
    eventBus.fire(OnConnectionStateEventBus(isConnected));
    if (!isConnected && wasConnected) {
      reconnect();
    }
  }

  bool initialized = false;
  Future<void> initService({bool force = false}) async {
    try {
      if (initialized && !force) {
        print("ignore second init");
        //print(StackTrace.current);
        // Note:
        // Currently some code - like get balance - is checking for init, and when not initialized,
        // it calls initialize. This gets called during initialization a few times, so this code is still
        // needed. Check init should probably just stall while initialize is happening?
        return;
      }
      initialized = true;
      print("PolkadotRepository init");

      _substrateService = SubstrateService(handleConnectState);

      await _substrateService!.init();

      state.isInitialized = true;

      await _cryptoWaitReady();

      await _initKeys();

      print("PolkadotRepository initService success");
    } catch (err) {
      print("PolkadotRepository initService Error: $err");
      rethrow;
    }
  }

  Future<bool> startService() async {
    try {
      print("PolkadotRepository start");

      if (state.isInitialized == false) {
        throw "startService repo not initialized";
      }
      if (state.isConnected == true) {
        throw "startService service already started";
      }

      await _substrateService!.connect();

      print("PolkadotRepository connected");
      state.isConnected = true;

      eventBus.fire(const OnWalletRefreshEventBus());

      return true;
    } catch (err) {
      print("Polkadot Service start Error: $err");
      state.isConnected = false;

      rethrow;
    }
  }

  Future<bool> stopService() async {
    try {
      await _substrateService?.stop();
    } catch (error) {
      print("ignoring substrate service stop error $error");
    }
    _substrateService = null;
    state.isInitialized = false;
    state.isConnected = false;

    return true;
  }

  Future<void> disconnect() async {
    await _substrateService!.webView.evalJavascript('api.disconnect()');
  }

  bool get isReady => state.isConnected == true;

  /// This is a little hack
  /// Before any crypto call, we must call cryptoWaitReady in the polkadot JS code
  /// However the wrapper does not expose that method
  /// However, it exposes another method that calls cryptoWaitready, which is initKeys()
  /// So we simply call initKeys() with empty parameters - it calls crypto wait ready and doesn't
  /// do anything else.
  /// [POLKA] Fix the JS API to export cryptoWaitReady - when we have time
  Future<void> _cryptoWaitReady() async {
    final res = await _substrateService?.webView.evalJavascript('keyring.initKeys([], [])');
    print("wait ready res: $res");
  }

  Future<void> _initKeys() async {
    final keys = await accountService.getPrivateKeys();

    for (final mnemonic in keys) {
      print("PJS: import key ${mnemonic.length}");
      await importKey(mnemonic);
    }
  }

  Future<String> createKey() async {
    if (!isReady) {
      throw "createKey: service not ready";
    }

    final res = await _substrateService?.webView.evalJavascript('keyring.gen(null, 42, "sr25519", "")');
    //print("create res: $res");
    final String mnemonic = res["mnemonic"];
    //print("mnemonic $mnemonic");
    return mnemonic;
  }

  bool isReconnecting = false;

  Future<void> reconnect() async {
    if (isConnected) {
      print("connected - not restarting");
      return;
    }
    // if (isReconnecting) {
    //   print("ignore reconnect while reconnecting");
    //   return;
    // }
    print("reconnecting...");

    isReconnecting = true;

    try {
      print("STOP SERVICE");
      await polkadotRepository.stopService();

      print("INIT SERVICE");

      await polkadotRepository.initService(force: true);

      print("START SERVICE");
      await polkadotRepository.startService();
      print("DONE SERVICE");
      isReconnecting = false;
    } catch (error) {
      isReconnecting = false;
      print("reconnect error $error");
      rethrow;
    }
  }

  Future<Result<Account?>> getIdentity(String address) async {
    try {
      print("get identity for $address");
      if (!isReady) {
        print("getIdentity: service not ready...");
        return Result.error("not ready");
      }

      final resJson =
          await _substrateService?.webView.evalJavascript('account.getAccountIndex(api, ${jsonEncode([address])})');

      // print("result  $resJson");
      // : result  [{accountId: 5GwwAKFomhgd4AHXZLUBVK3B792DvgQUnoHTtQNkwmt5h17k, identity: {display: Nikolaus Heger, judgements: [], other: {}}}]

      final displayName = resJson[0]["identity"]["display"];

      print("displayName $displayName");

      return Result.value(Account(address: address, name: displayName));
    } catch (error) {
      print("Error getting identity $error");
      return Result.error("Error getting identity: $error");
    }
  }

  // api.query.system.account(steve.address)
  Future<Result<BalanceModel>> getBalance(String address) async {
    try {
      print("get balance for $address");
      if (!isReady) {
        print("getBalance: service not ready...");
        return Result.error("Not ready");
      }

      final resJson = await _substrateService?.webView.evalJavascript('api.query.system.account("$address")');

      // print("result STRING $resJson");
      // flutter: result STRING: {nonce: 0, consumers: 0, providers: 0, sufficients: 0, data: {free: 0, reserved: 0, miscFrozen: 0, feeFrozen: 0}}
      final free = resJson["data"]["free"];
      final freeString = "$free";
      final bigNum = BigInt.parse(freeString);
      final double result = bigNum.toDouble() / pow(10, hashedToken.precision);

      return Result.value(BalanceModel(result));
    } catch (error) {
      print("Error getting balance $error");
      print(error);
      return Result.error(error);
    }
  }

  Future<Result<int>> getLastBlockNumber() async {
    try {
      print("get last block number");

      final resJson = await _substrateService?.webView.evalJavascript('api.rpc.chain.getBlock()');
      final block = SubstrateBlock.fromJson(resJson["block"]);
      return Result.value(block.header.number);
    } catch (error) {
      print("Error getting block number $error");
      return Result.error(error);
    }
  }

  Future<dynamic> testImport() async {
    if (!isReady) {
      throw "testImport: service not ready";
    }

    // known mnemonic, well, now it is - don't use it for funds
    final mnemonicFromPolkaTutorial = 'sample split bamboo west visual approve brain fox arch impact relief smile';
    final res = await importKey(mnemonicFromPolkaTutorial);
    return res;
  }

  Future<String> importKey(String mnemonic) async {
    if (!isInitialized) {
      throw "importKey: service not ready";
    }

    /// Notes
    /// 1 - Variables declared raw are global variables
    /// 2 - Here we use last_pair to store the last added keypair so we can return it
    /// 3 - We have to stringify the result since we otherwise get an unsupported type exception and nothing
    /// is returned.
    /// 4 - without debug output could use the method with wrapPromise = true and would probably get the result
    final code = '''
      console.log(keyring.pKeyring, 'pkeyring before');
      console.log(keyring.pKeyring.pairs.length, 'pairs before');

      // generic substrate format
      keyring.pKeyring.setSS58Format(42);

      // create & add the pair to the keyring with the type and some additional
      // metadata specified
      last_pair = keyring.pKeyring.addFromUri("$mnemonic", { name: 'first pair' }, 'sr25519');

      // the pair has been added to our keyring
      console.log(keyring.pKeyring.pairs.length, 'pairs available');


      // log the name & address (the latter encoded with the ss58Format)
      // console.log(last_pair.meta.name, ' ==> ', JSON.stringify(last_pair, null, 2));

      // return result
      JSON.stringify(last_pair);
    ''';
    try {
      final res = await _substrateService?.webView.evalJavascript(code, wrapPromise: false);
      print("result importKey $res");
      if (res is String) {
        final jsonRes = jsonDecode(res);
        return jsonRes["address"];
      } else {
        return res["address"];
      }
    } catch (err) {
      print("import key error $err");
      rethrow;
    }
  }

  @override
  Future<String?> publicKeyForPrivateKey(String privateKey) async {
    if (!isReady) {
      throw "publicKeyForPrivateKey: service not ready";
    }

    /// 1 - set format
    /// 2 - call addFromUri, which returns a keypair object
    /// 3 - encode the keypair in JSON so we return a string
    /// Flutter code can then JSON decode the string
    final code = '''
      keyring.pKeyring.setSS58Format(42);
      last_pair = keyring.pKeyring.addFromUri("$privateKey", { name: '' }, 'sr25519');
      JSON.stringify(last_pair);
    ''';
    try {
      final res = await _substrateService?.webView.evalJavascript(code, wrapPromise: false);
      final json = jsonDecode(res);
      return json["address"];
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }

  Future<String?> privateKeyForPublicKey(String publicKey) async {
    if (!isReady) {
      throw "privateKeyForPublicKey: service not ready";
    }

    final keys = await accountService.getPrivateKeys();

    for (final key in keys) {
      final pk = await publicKeyForPrivateKey(key);
      if (pk == publicKey) {
        return key;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> getKeyPair(String address) async {
    final code = 'JSON.stringify(keyring.pKeyring.getPair("$address"))';
    final res = await _substrateService?.webView.evalJavascript(code, wrapPromise: false);
    final keyPair = jsonDecode(res);
    return keyPair;
  }

  /// Note: The APIs sometimes take a public key instead of an address - this converts
  /// one into the other. Public key is in map format but the function u8aToHex converts that
  /// correctly to hex.
  Future<Map<String, dynamic>> getPublicKey(String address) async {
    final keyPair = await getKeyPair(address);
    final pubkey = keyPair["publicKey"];
    return pubkey;
  }

  int getBlockTimeSeconds() {
    return 6;
  }
}
