import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/local/flutter_js/polkawallet_init.dart';
import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/utils/result_extension.dart';

PolkadotRepository polkadotRepository = PolkadotRepository();

enum PolkadotRepositoryState {
  stopped,
  initialized,
  connected,
  disconnected,
}

class PolkadotRepository extends KeyRepository {
  late PolkawalletInit? _polkawalletInit;

  bool get isInitialized => state == PolkadotRepositoryState.initialized;
  bool get isConnected => state == PolkadotRepositoryState.connected;
  PolkadotRepositoryState state = PolkadotRepositoryState.stopped;

  void handleConnectState(bool isConnected) {
    print("PolkadotRepository connection state ${isConnected ? 'Connected' : 'Disconnected'}");
    if (isConnected) {
      state = PolkadotRepositoryState.connected;
    } else {
      state = PolkadotRepositoryState.disconnected;
    }
  }

  Future<void> initService() async {
    try {
      print("PolkadotRepository init");

      _polkawalletInit = PolkawalletInit(handleConnectState);

      await _polkawalletInit!.init();

      state = PolkadotRepositoryState.initialized;
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }

  Future<bool> startService() async {
    try {
      print("PolkadotRepository start");
      _polkawalletInit = PolkawalletInit(handleConnectState);
      await _polkawalletInit!.init();
      await _polkawalletInit!.connect();
      state = PolkadotRepositoryState.connected;

      return true;
    } catch (err) {
      print("Error: $err");
      state = PolkadotRepositoryState.disconnected;

      rethrow;
    }
  }

  Future<bool> stopService() async {
    await _polkawalletInit?.stop();
    _polkawalletInit = null;
    state = PolkadotRepositoryState.stopped;

    return true;
  }

  Future<void> _checkInitialized() async {
    switch (state) {
      case PolkadotRepositoryState.stopped:
        await initService();
        break;
      case PolkadotRepositoryState.initialized:
      case PolkadotRepositoryState.connected:
      case PolkadotRepositoryState.disconnected:
        return;
    }
  }

  Future<void> _checkConnected() async {
    switch (state) {
      case PolkadotRepositoryState.stopped:
      case PolkadotRepositoryState.disconnected:
        await startService();
        break;
      case PolkadotRepositoryState.initialized:
      case PolkadotRepositoryState.connected:
        return;
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

  Future<String> createKey() async {
    await _checkInitialized();

    await _cryptoWaitReady();
    final res = await _polkawalletInit?.webView?.evalJavascript('keyring.gen(null, 42, "sr25519", "")');
    //print("create res: $res");
    final String mnemonic = res["mnemonic"];
    //print("mnemonic $mnemonic");
    return mnemonic;
  }

  // api.query.system.account(steve.address)
  Future<dynamic> getBalance(String address) async {
    await _checkConnected();
    final res = await _polkawalletInit?.webView?.evalJavascript('api.query.system.account("$address")');
    print("getBalance res: $res");
    return res;
  }

  Future<dynamic> testImport() async {
    await _checkInitialized();
    // known mnemonic, well, now it is - don't use it for funds
    final mnemonicFromPolkaTutorial = 'sample split bamboo west visual approve brain fox arch impact relief smile';
    final res = await importKey(mnemonicFromPolkaTutorial);
    return res;
  }

  Future<Account> importKey(String mnemonic) async {
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
      return Account(name: "", address: res["address"]);
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }

  @override
  Future<String?> publicKeyForPrivateKey(String privateKey) async {
    await _checkInitialized();

    // TODO(n13): implement publicKeyForPrivateKey
    throw UnimplementedError();
  }

  Future<Result> initGuardians(List<String> guardians) async {
    throw UnimplementedError();
  }

  Future<Result> cancelGuardians() async {
    throw UnimplementedError();
  }

  Future<Result> getAccountRecovery() async {
    throw UnimplementedError();
  }

  Future<Result> getAccountGuardians() async {
    throw UnimplementedError();
  }
}
