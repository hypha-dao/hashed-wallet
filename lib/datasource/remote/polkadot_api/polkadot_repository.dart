import 'package:seeds/datasource/local/flutter_js/polkawallet_init_2.dart';

PolkadotRepository polkadotRepository = PolkadotRepository();

class PolkadotRepository {
  late PolkawalletInit2? _polkawalletInit;

  bool get isRunning => _polkawalletInit != null;

  Future<bool> startService() async {
    try {
      print("PolkadotRepository init");

      _polkawalletInit = PolkawalletInit2();

      await _polkawalletInit!.startApp();

      print("JS is running...");

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
    //console.log("hello JS, this is createKey");
    // Note: "gen" returns a full key JSON, and also adds the new key to the keyring

    final res = await _polkawalletInit?.webView?.evalJavascript('keyring.gen(null, 42, "sr25519", "")');
    print("create res: $res");
    final String mnemonic = res["mnemonic"];
    // String mnemonic = res["mnemonic"];
    print("mnemonic $mnemonic");
    return mnemonic;
  }

  Future<dynamic> testImport() async {
    // known mnemonic, well, now it is - don't use it for funds
    final mnemonicFromPolkaTutorial = 'sample split bamboo west visual approve brain fox arch impact relief smile';
    final res = await importKey(mnemonicFromPolkaTutorial);
    return res;
  }

  Future<dynamic> importKey(String mnemonic) async {
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
      return res;
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }
}
