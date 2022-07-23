import 'package:seeds/datasource/local/flutter_js/polkawallet_init_2.dart';

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
    await _polkawalletInit?.walletSdk.webView?.dispose();
    _polkawalletInit = null;
    return true;
  }

  Future<dynamic> createKey() async {}
}
