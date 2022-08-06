import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/local/flutter_js/polkawallet_init.dart';
import 'package:seeds/datasource/remote/model/guardians_config_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/api/types/txInfoData.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/service/webViewRunner.dart';
import 'package:seeds/utils/result_extension.dart';

PolkadotRepository polkadotRepository = PolkadotRepository();

class PolkadotRepositoryState {
  bool isInitialized = false;
  bool isConnected = false;
}

class PolkadotRepository extends KeyRepository {
  late PolkawalletInit? _polkawalletInit;

  bool get isInitialized => state.isInitialized;
  bool get isConnected => state.isConnected;

  PolkadotRepositoryState state = PolkadotRepositoryState();

  void handleConnectState(bool isConnected) {
    print("PolkadotRepository connection state ${isConnected ? 'Connected' : 'Disconnected'}");
    state.isConnected = isConnected;
  }

  bool initialized = false;
  Future<void> initService() async {
    try {
      if (initialized) {
        print("ignore second init");
        print(StackTrace.current);
        return;
      }
      initialized = true;
      print("PolkadotRepository init");

      _polkawalletInit = PolkawalletInit(handleConnectState);

      await _polkawalletInit!.init();

      state.isInitialized = true;

      await _cryptoWaitReady();
      await _initKeys();
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }

  Future<bool> startService() async {
    try {
      print("PolkadotRepository start");
      await _polkawalletInit!.init();
      await _polkawalletInit!.connect();
      state.isConnected = true;

      return true;
    } catch (err) {
      print("Error: $err");
      state.isConnected = false;

      rethrow;
    }
  }

  Future<bool> stopService() async {
    await _polkawalletInit?.stop();
    _polkawalletInit = null;
    state.isInitialized = false;

    return true;
  }

  Future<void> _checkInitialized() async {
    if (state.isInitialized == false) {
      await initService();
    }
  }

  Future<void> _checkConnected() async {
    await _checkInitialized();
    if (state.isConnected == false) {
      await startService();
    }
  }

  /// This is a little hack
  /// Before any crypto call, we must call cryptoWaitReady in the polkadot JS code
  /// However the wrapper does not expose that method
  /// However, it exposes another method that calls cryptoWaitready, which is initKeys()
  /// So we simply call initKeys() with empty parameters - it calls crypto wait ready and doesn't
  /// do anything else.
  /// [POLKA] Fix the JS API to export cryptoWaitReady - when we have time
  Future<void> _cryptoWaitReady() async {
    // async function initKeys(accounts: KeyringPair$Json[], ss58Formats: number[]) {
    final res = await _polkawalletInit?.webView?.evalJavascript('keyring.initKeys([], [])');
    print("wait ready res: $res");
  }

  Future<void> _initKeys() async {
    final keys = await accountService.getPrivateKeys();

    for (final mnemonic in keys) {
      print("PJS: import key $mnemonic");
      await importKey(mnemonic);
    }
  }

  Future<String> createKey() async {
    await _checkInitialized();

    final res = await _polkawalletInit?.webView?.evalJavascript('keyring.gen(null, 42, "sr25519", "")');
    //print("create res: $res");
    final String mnemonic = res["mnemonic"];
    //print("mnemonic $mnemonic");
    return mnemonic;
  }

  // api.query.system.account(steve.address)
  Future<double> getBalance(String address) async {
    try {
      print("get balance for $address");
      await _checkInitialized();
      await _checkConnected();

      // Debug code, do not check in - checking account with known address
      // final knownAddress = "5GwwAKFomhgd4AHXZLUBVK3B792DvgQUnoHTtQNkwmt5h17k";
      // final resJson = await _polkawalletInit?.webView?.evalJavascript('api.query.system.account("$knownAddress")');

      final resJson = await _polkawalletInit?.webView?.evalJavascript('api.query.system.account("$address")');

      // print("result STRING $resJson");
      // flutter: result STRING: {nonce: 0, consumers: 0, providers: 0, sufficients: 0, data: {free: 0, reserved: 0, miscFrozen: 0, feeFrozen: 0}}

      /// this value is an int if it's small enough.
      /// Not sure what will happen if the number is too big but one would assume it
      /// would then get sent as a string. So we always convert it to a string.
      final free = resJson["data"]["free"];
      final freeString = "$free";
      final bigNum = BigInt.parse(freeString);
      final double result = bigNum.toDouble() / pow(10, hashedToken.precision);

      //print("free type: ${free.runtimeType} ==> $bigNum ==> $result");

      return result;
    } catch (error) {
      print("Error getting balance $error");
      print(error);
      rethrow;
    }
  }

  Future<dynamic> testImport() async {
    await _checkInitialized();
    // known mnemonic, well, now it is - don't use it for funds
    final mnemonicFromPolkaTutorial = 'sample split bamboo west visual approve brain fox arch impact relief smile';
    final res = await importKey(mnemonicFromPolkaTutorial);
    return res;
  }

  Future<String> importKey(String mnemonic) async {
    await _checkInitialized();

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
      final res = await _polkawalletInit?.webView?.evalJavascript(code, wrapPromise: false);
      print("result importKey $res");
      return res["address"];
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }

  @override
  Future<String?> publicKeyForPrivateKey(String privateKey) async {
    await _checkInitialized();

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
      final res = await _polkawalletInit?.webView?.evalJavascript(code, wrapPromise: false);
      final json = jsonDecode(res);
      return json["address"];
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }

  Future<String?> privateKeyForPublicKey(String publicKey) async {
    await _checkInitialized();

    final keys = await accountService.getPrivateKeys();

    for (final key in keys) {
      final pk = await publicKeyForPrivateKey(key);
      if (pk == publicKey) {
        return key;
      }
    }
    return null;
  }

  Future<Result> getKeyPair(String address) async {
    final code = 'keyring.pKeyring.getPair("$address")';
    final res = await _polkawalletInit?.webView?.evalJavascript(code);
    print("getKeyPair res: $res");
    return Result.value(res);
  }

  Future<Result> initGuardians(List<String> guardians) async {
    final address = accountService.currentAccount.address;
//     final code = '''
// const createRecovery = await api.tx.recovery.createRecovery(
//     [
//       <friend_1_public_key>,
//       <friend_2_public_key>
//     ], 2, 0)
//     .signAndSend(steve);
// console.log( createRecovery.toHex() );
// '''
    final code =
        'api.tx.recovery.createRecovery([${guardians.join(",")}].sort(), 2, 0).signAndSend(keyring.pKeyring.getPair("$address"))';
    final res = await _polkawalletInit?.webView?.evalJavascript(code);
    print("initGuardians res: $res");
    return Result.value(res);
  }

  Future<Result> cancelGuardians() async {
    final address = accountService.currentAccount.address;

    final code = 'api.tx.recovery.removeRecovery().signAndSend(keyring.pKeyring.getPair($address))';
    final res = await _polkawalletInit?.webView?.evalJavascript(code);
    print("cancelGuardians res: $res");
    return Result.value(res);
  }

  Future<Result> getActiveRecovery() async {
    throw UnimplementedError();
  }

  Future<Result<GuardiansConfigModel>> getRecoveryConfig(String address) async {
    print("get guardians for $address");

    // TODO(n13): Create a mapper for polkadot API results - similar to httpmapper
    // then add model mappers for all the different possible responses.
    // But, make it work first -
    try {
      // const testAddr = "5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym"; // DEBUG REMOVE
      final code = 'api.query.recovery.recoverable("$address")';
      final res = await _polkawalletInit?.webView?.evalJavascript(code);
      print("getRecoveryConfig res: $res");
      GuardiansConfigModel guardiansModel;
      if (res != null) {
        res['address'] = address;
        guardiansModel = GuardiansConfigModel.fromJson(res);
      } else {
        guardiansModel = GuardiansConfigModel.empty;
      }
      return Future.value(Result.value(guardiansModel));
    } catch (err) {
      return Future.value(Result.error(err));
    }
  }
}

// This code extracted from the SDK
class SendTransactionHelper {
  final WebViewRunner _webView;

  SendTransactionHelper(this._webView);

  Future<void> sendTx({
    required String address,
    required String pubKey,
    required String to,
    required String amount,
  }) async {
    final sender = TxSenderData(
      address,
      pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);
    try {
      final hash = await signAndSend(
        txInfo,
        [
          to,
          amount,
          // // _testAddressGav,
          // 'GvrJix8vF8iKgsTAfuazEDrBibiM6jgG66C6sT2W56cEZr3',
          // // params.amount
          // '10000000000'
        ],
        "",
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendTx ${hash.toString()}');
    } catch (err) {
      print('sendTx ERROR $err');
    }
  }

  /// Send tx, [params] will be ignored if we have [rawParam].
  /// [onStatusChange] is a callback when tx status change.
  /// @return txHash [string] if tx finalized success.
  ///
  /// Sign and send is a complex structure that's simplified with this API
  ///
  /// All we need to do is create a TxInfoData object and parameters and we're
  /// good to go
  ///
  /// onStatusChange will be called when the event changes status - is included in a block
  /// or finalized of has an error
  ///
  /// The function returns txHash on success, and throws an error if not successful
  ///
  /// Execution takes block time, meaning around 6 seconds. As it is waiting for the
  /// transaction to be processed.
  ///
  Future<Map> signAndSend(
    TxInfoData txInfo,
    List params,
    String password, {
    Function(String)? onStatusChange,
    String? rawParam,
  }) async {
    // ignore: prefer_if_null_operators
    final param = rawParam != null ? rawParam : jsonEncode(params);
    final Map tx = txInfo.toJson();
    print(tx);
    print(param);
    final res = await (serviceSignAndSend(
      tx,
      param,
      password,
      onStatusChange ?? (status) => print(status),
    ) as FutureOr<Map<dynamic, dynamic>>);
    if (res['error'] != null) {
      throw Exception(res['error']);
    }
    return res;
  }

  Future<Map?> serviceSignAndSend(Map txInfo, String params, String password, Function(String) onStatusChange) async {
    final msgId = "onStatusChange${_webView.getEvalJavascriptUID()}";
    _webView.addMsgHandler(msgId, onStatusChange);
    final code = 'keyring.sendTx(api, ${jsonEncode(txInfo)}, $params, "$password", "$msgId")';
    print("serviceSignAndSend: $code");
    final dynamic res = await _webView.evalJavascript(code);
    _webView.removeMsgHandler(msgId);
    return res;
  }
}
