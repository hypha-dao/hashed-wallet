import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:seeds/datasource/local/flutter_js/polkawallet_init.dart';
import 'package:seeds/datasource/local/flutter_js/polkawallet_init_2.dart';

class JSInit {
  // final String homeUrl = "http://localhost:8080/assets/polkadot/web/demo.html";
  final String homeUrl = "http://localhost:8080/assets/polkadot/web/index.html";

  static HeadlessInAppWebView? webView;
  // bundle-polkadot-util.js
  String testPolkadotUtil = """
      console.log('polkadotUtil XX');

      // console.log("pkutil: "+polkadotUtil + " " + window.polkadotUtil.u8aToHex);

      // the following is correct since the in app web view script has its own namespace (I guess)
      const { bnToBn, u8aToHex } = polkadotUtil;

      console.log('u8aToHex XX', u8aToHex(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8])));
    """;

  String testPolkadotUtilCrypto = """
      console.log('polkadotUtilCrypto XX');

      const { blake2AsHex, randomAsHex, selectableNetworks } = polkadotUtilCrypto;

      console.log('blake2AsHex XX', blake2AsHex(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8])));

    """;

  late PolkawalletInit2? _polkawalletInit;

  Future<void> init() async {
    try {
      print("js init");

      _polkawalletInit = PolkawalletInit2();

      await _polkawalletInit!.startApp();

      print("JS is running...");
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }
}
