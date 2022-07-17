import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class JSInit {
  // JavascriptRuntime runtime = getJavascriptRuntime();

  static HeadlessInAppWebView? webView;
  // bundle-polkadot-util.js
  String testPolkadotUtil = """
      console.log('polkadotUtil');

      const { bnToBn, u8aToHex } = polkadotUtil;

      console.log('u8aToHex', u8aToHex(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8])));
    """;

  Future<void> init() async {
    try {
      print("create wv");
      webView = await createWebView();
      await webView!.run();

      print("done creating $webView");
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }

  Future<void> _loadJS(InAppWebViewController controller) async {
    final String polkadotUtilBundle = await rootBundle.loadString('assets/polkadot/bundles/bundle-polkadot-util.js');

    print("loading polkadotUtilBundle ${polkadotUtilBundle.length / 1000.0}");

    print("init...");
    // final res = await controller.evaluateJavascript(source: polkadotUtilBundle);
    final res = await controller.injectJavascriptFileFromAsset(
        assetFilePath: 'assets/polkadot/bundles/bundle-polkadot-util.js');

    print(res);

    print("test...");

    final r1 = await controller.evaluateJavascript(source: testPolkadotUtil);
    print(r1);
  }

  Future<HeadlessInAppWebView> createWebView() async {
    final String fileText = await rootBundle.loadString('assets/polkadot/web/index.html');
    final Uri dataUri = Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
    final URLRequest initialRequest = URLRequest(url: dataUri);

    final result = HeadlessInAppWebView(
      // initialFile: "assets/polkadot/web/index.html", // this should work too...
      initialUrlRequest: initialRequest,
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

        Future.delayed(const Duration(seconds: 2), () async => {await _loadJS(controller)});

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
    return result;
  }

  Future<void> _loadHtmlFromAssets(HeadlessInAppWebView webView) async {
    final String fileText = await rootBundle.loadString('assets/polkadot/web/index.html');
    final Uri dataUri = Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
    final URLRequest request = URLRequest(url: dataUri);
    await webView.webViewController.loadUrl(urlRequest: request);
  }
}
