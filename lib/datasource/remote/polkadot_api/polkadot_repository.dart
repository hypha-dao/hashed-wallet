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
        //print(StackTrace.current);
        // Note:
        // Currently some code - like get balance - is checking for init, and when not initialized,
        // it calls initialize. This gets called during initialization a few times, so this code is still
        // needed. Check init should probably just stall while initialize is happening?
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

  Future<Map<String, dynamic>> getKeyPair(String address) async {
    final code = 'JSON.stringify(keyring.pKeyring.getPair("$address"))';
    final res = await _polkawalletInit?.webView?.evalJavascript(code, wrapPromise: false);
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

  Future<Result> initGuardians(GuardiansConfigModel guardians) async {
    print("create recovery: ${guardians.toJson()}");
    final res = SendTransactionHelper(_polkawalletInit!.webView!).sendCreateRecovery(
      address: accountService.currentAccount.address,
      guardians: guardians.guardianAddresses,
      threshold: guardians.threshold,
      delayPeriod: guardians.delayPeriod,
    );

    print("initGuardians res: $res");
    return Result.value(res);
  }

  Future<Result> cancelGuardians() async {
    // final address = accountService.currentAccount.address;

    // final code = 'api.tx.recovery.removeRecovery().signAndSend(keyring.pKeyring.getPair("$address"))';
    // final res = await _polkawalletInit?.webView?.evalJavascript(code);
    // print("cancelGuardians res: $res");
    // return Result.value(res);

    final res = SendTransactionHelper(_polkawalletInit!.webView!)
        .sendRemoveRecovery(address: accountService.currentAccount.address);

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

  Future<String?> testSendRecovery() async {
    print("execute testSendRecovery");
    // mnemonic: someone course sketch usage whisper helmet juice oyster rebuild razor mobile announce
    const acct_0 = "5FyG1HpMSce9As8Uju4rEQnL24LZ8QNFDaKiu5nQtX6CY6BH";
    // mnemonic: dress teach unveil require supply move butter sort cruise divide nice account
    const acct_1 = "5Ca9Sdw7dxUK62FGkKXSZPr8cjNLobuGAgXu6RCM14aKtz6T";
    // mnemonic: slogan crime relief smile door make deliver staff lonely hello worry sure
    const acct_2 = "5C8126sqGbCa3m7Bsg8BFQ4arwcG81Vbbwi34EznBovrv7Zf";

    final keyPair = await getKeyPair(accountService.currentAccount.address);

    print("keyPair ${keyPair}");

    final publicKey = await getPublicKey(accountService.currentAccount.address);

    print("publicKey ${publicKey}");

    return SendTransactionHelper(_polkawalletInit!.webView!).sendCreateRecovery(
      address: accountService.currentAccount.address,
      guardians: [
        acct_0,
        acct_1,
        acct_2,
      ],
      threshold: 2,
      delayPeriod: GuardiansConfigModel.defaultDelayPeriod,
    );
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

  Future<String?> sendRecovery2() async {
    final code = '''
new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery.removeRecovery()
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Remove Recovery: Current status is \${status.type}`);
  
        if (status.isFinalized) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash \${status.asFinalized}`);
          console.log(`Transaction hash \${txHash.toHex()}`);
  
          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            console.log(`\t' \${phase}: \${section}.\${method}:: \${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            } 
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()
          // => 
          // ' {"applyExtrinsic":1}: balances.Withdraw:: ["5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym",85795211]
          // ' {"applyExtrinsic":1}: system.ExtrinsicFailed:: [{"module":{"index":10,"error":"0x04000000"}},{"weight":148937000,"class":"Normal","paysFee":"Yes"}]
         
          resolve({
            events,
            status,
            txHash,
            transactionSuccess,
          })
  
        }
      });
  })
    ''';
    final res = await _webView.evalJavascript(code);
    print("sendRecovery2 res: $res");
    return res;
  }

  Future<String?> sendCreateRecovery({
    required String address,
    required List<String> guardians,
    required int threshold,
    required int delayPeriod,
  }) async {
    final sender = TxSenderData(
      address,
      "",
    );
    final txInfo = TxInfoData('recovery', 'createRecovery', sender);
    guardians.sort();
    print("sorted guards: $guardians");

    try {
      final hash = await signAndSend(
        txInfo,
        [
          guardians,
          threshold,
          delayPeriod,
        ],
        "",
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendTx ${hash.toString()}');
      return hash.toString();
    } catch (err) {
      print('sendTx ERROR $err');
      return null;
    }
  }

  Future<String?> sendRemoveRecovery({
    required String address,
  }) async {
    final sender = TxSenderData(
      address,
      "",
    );
    final txInfo = TxInfoData('recovery', 'removeRecovery', sender);

    try {
      final hash = await signAndSend(
        txInfo,
        [],
        null,
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendRemoveRecovery ${hash.toString()}');
      return hash.toString();
    } catch (err) {
      print('sendRemoveRecovery ERROR $err');
      return null;
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
    String? password, {
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

  Future<Map?> serviceSignAndSend(Map txInfo, String params, String? password, Function(String) onStatusChange) async {
    final msgId = "onStatusChange${_webView.getEvalJavascriptUID()}";
    _webView.addMsgHandler(msgId, onStatusChange);
    final code = 'keyring.sendTransaction(api, ${jsonEncode(txInfo)}, $params, "$msgId")';
    print("serviceSignAndSend: $code");
    final dynamic res = await _webView.evalJavascript(code);
    _webView.removeMsgHandler(msgId);
    return res;
  }
}
