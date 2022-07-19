import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
    // final String polkadotUtilBundle = await rootBundle.loadString('assets/polkadot/bundles/bundle-polkadot-util.js');

    // print("loading polkadotUtilBundle ${polkadotUtilBundle.length / 1000.0}");

    print("init...");
    // final res = await controller.evaluateJavascript(source: polkadotUtilBundle);
    // final res = await controller.injectJavascriptFileFromAsset(
    //     assetFilePath: 'assets/polkadot/bundles/bundle-polkadot-util.js');

    // print(res);

    print("test...evaluateJavascript");
    try {
      // final r1 = await controller.evaluateJavascript(source: testPolkadotUtilCrypto);
      // print("test res");
      // print(r1);
    } catch (err) {
      print("errorX: $err");
      print(err);
    }
  }

  // Future<String> insertScript(String text, String bundleName) async {
  //   final tag = "tag-$bundleName";
  //   final String bundleContents = await rootBundle.loadString('assets/polkadot/bundles/$bundleName.js');
  //   print("loading bundle $bundleName: ${bundleContents.length / 1000.0}");
  //   return text.replaceFirst(tag, bundleContents);
  // }

  Future<HeadlessInAppWebView> createWebView() async {
    // String fileText = await rootBundle.loadString('assets/polkadot/web/index.html');
    //fileText = await insertScript(fileText, "bundle-polkadot-util");
    // final tag = "tag-bundle-polkadot-util";
    // final String bundleContents = await rootBundle.loadString('assets/polkadot/bundles/bundle-polkadot-util.js');
    // fileText = fileText.replaceFirst(tag, bundleContents);
    // print("file text $fileText");
    //fileText = await insertScript(fileText, "bundle-polkadot-util-crypto");

    // final Uri dataUri = Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
    // final URLRequest initialRequest = URLRequest(url: dataUri);

    final result = HeadlessInAppWebView(
      // initialFile: "assets/polkadot/web/index.html", // this should work too...
      initialUrlRequest: URLRequest(url: Uri.parse(homeUrl)),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
        cacheEnabled: false,
        clearCache: true,
      )),
      onLoadError: (controller, url, code, message) {
        print("on load error $message");
      },
      onLoadHttpError: (controller, url, code, message) {
        print("on onLoadHttpError $message");
      },
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
        print("onLoadStop:");

        Future.delayed(const Duration(seconds: 4), () => _loadJS(controller));

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

  // Future<void> _loadHtmlFromAssets(HeadlessInAppWebView webView) async {
  //   final String fileText = await rootBundle.loadString('assets/polkadot/web/index.html');
  //   final Uri dataUri = Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
  //   final URLRequest request = URLRequest(url: dataUri);
  //   await webView.webViewController.loadUrl(urlRequest: request);
  // }
}
