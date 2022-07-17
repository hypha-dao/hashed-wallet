import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_js/flutter_js.dart';

class JSInit {
  // JavascriptRuntime runtime = getJavascriptRuntime();

  // bundle-polkadot-util.js
  String testPolkadotUtil = """
      console.log('polkadotUtil');

      const { bnToBn, u8aToHex } = polkadotUtil;

      console.log('u8aToHex', u8aToHex(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8])));
    """;

  Future<void> init() async {
    try {
      final String polkadotUtilBundle = await rootBundle.loadString('assets/polkadot/bundles/bundle-polkadot-util.js');

      print("loading polkadotUtilBundle ${polkadotUtilBundle.length / 1000.0}");

      final webView = createWebView();

      // final r1 = await runtime.evaluateAsync(polkadotUtilBundle);
      // print("eval res:");
      // print(r1);

      // print(runtime.evaluate(testPolkadotUtil));

      //   print("init done ");
      //   print("result: $res");

    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }

  HeadlessInAppWebView createWebView() {
    return HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse("https://github.com/flutter")),
      onWebViewCreated: (controller) {
        print("webview create");
        // final snackBar = const SnackBar(
        //   content: Text('HeadlessInAppWebView created!'),
        //   duration: Duration(seconds: 1),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("Console Message: ${consoleMessage.message}");
        // final snackBar = SnackBar(
        //   content: Text('Console Message: ${consoleMessage.message}'),
        //   duration: Duration(seconds: 1),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onLoadStart: (controller, url) async {
        print("onLoadStart: $url");
        // final snackBar = SnackBar(
        //   content: Text('onLoadStart $url'),
        //   duration: Duration(seconds: 1),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // setState(() {
        //   this.url = url?.toString() ?? '';
        // });
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop: $url");
        // final snackBar = SnackBar(
        //   content: Text('onLoadStop $url'),
        //   duration: Duration(seconds: 1),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // setState(() {
        //   this.url = url?.toString() ?? '';
        // });
      },
    );
  }
}
