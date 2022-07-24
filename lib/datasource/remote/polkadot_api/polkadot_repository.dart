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
    final res = await _polkawalletInit?.webView?.evalJavascript('keyring.gen(null, 42, "sr25519", "")');
    print("create res: $res");
    final String mnemonic = res["mnemonic"];
    // String mnemonic = res["mnemonic"];
    print("mnemonic $mnemonic");
    return mnemonic;
  }
}
