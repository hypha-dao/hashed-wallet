import 'package:seeds/datasource/local/flutter_js/polkawallet_init.dart';
import 'package:seeds/datasource/local/models/account.dart';

PolkadotRepository polkadotRepository = PolkadotRepository();

class PolkadotRepository {
  late PolkawalletInit? _polkawalletInit;

  bool get isRunning => _polkawalletInit != null;

  Future<void> initService() async {
    try {
      print("PolkadotRepository init");

      _polkawalletInit = PolkawalletInit();

      await _polkawalletInit!.init();
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }

  Future<bool> startService() async {
    try {
      print("PolkadotRepository start");
      _polkawalletInit = PolkawalletInit();
      await _polkawalletInit!.connect();
      return true;
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }

  Future<bool> stopService() async {
    await _polkawalletInit?.stop();
    _polkawalletInit = null;
    return true;
  }

  Future<String> createKey() async {
    final res = await _polkawalletInit?.webView?.evalJavascript('keyring.gen(null, 42, "sr25519", "")');
    //print("create res: $res");
    final String mnemonic = res["mnemonic"];
    //print("mnemonic $mnemonic");
    return mnemonic;
  }

  // api.query.system.account(steve.address)
  Future<dynamic> getBalance(String address) async {
    final res = await _polkawalletInit?.webView?.evalJavascript('api.query.system.account("$address")');
    print("getBalance res: $res");
    return res;
  }

  Future<dynamic> testImport() async {
    // known mnemonic, well, now it is - don't use it for funds
    final mnemonicFromPolkaTutorial = 'sample split bamboo west visual approve brain fox arch impact relief smile';
    final res = await importKey(mnemonicFromPolkaTutorial);
    return res;
  }

  Future<Account> importKey(String mnemonic) async {
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
      return Account(res["address"], "");
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }
}
