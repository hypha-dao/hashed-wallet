// ignore_for_file: avoid_redundant_argument_values, unused_element, avoid_print, prefer_final_locals

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jaguar/jaguar.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/networkParams.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/jaguar_flutter_asset.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/service_keyring.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';

class WebViewRunner {
  HeadlessInAppWebView? _web;

  HeadlessInAppWebView? get web => _web;

  Function? _onLaunched;

  late String _jsCode;
  Map<String, Function> _msgHandlers = {};
  Map<String, Completer> _msgCompleters = {};
  int _evalJavascriptUID = 0;

  bool webViewLoaded = false;
  int jsCodeStarted = -1;
  Timer? _webViewReloadTimer;

  Future<void> launch(
    ServiceKeyring? keyring,
    Keyring keyringStorage,
    Function? onLaunched, {
    String? jsCode,
    Function? socketDisconnectedAction,
  }) async {
    /// reset state before webView launch or reload
    _msgHandlers = {};
    _msgCompleters = {};
    _evalJavascriptUID = 0;
    _onLaunched = onLaunched;
    webViewLoaded = false;
    jsCodeStarted = -1;

    _jsCode = jsCode ?? await rootBundle.loadString('assets/polkadot/main.js');
    print('*** js file loaded');

    if (_web == null) {
      // await _startLocalServer(); // no server needed - doesn't work
      // print("server started!");

      _web = HeadlessInAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(),
        ),
        onLoadStart: (controller, uri) {
          print("Load start $uri");
        },
        onWebViewCreated: (controller) {
          print('HeadlessInAppWebView created!');
        },
        onConsoleMessage: (controller, message) {
          print("CONSOLE MESSAGE: ${message.message}");
          if (jsCodeStarted < 0) {
            if (message.message.contains('js loaded')) {
              jsCodeStarted = 1;
            } else {
              jsCodeStarted = 0;
            }
          }
          if (message.message.contains("WebSocket is not connected") && socketDisconnectedAction != null) {
            socketDisconnectedAction();
          }
          if (message.messageLevel != ConsoleMessageLevel.LOG) {
            return;
          }

          try {
            final msg = jsonDecode(message.message);

            final String? path = msg['path'];
            if (_msgCompleters[path!] != null) {
              Completer handler = _msgCompleters[path]!;
              handler.complete(msg['data']);
              if (path.contains('uid=')) {
                _msgCompleters.remove(path);
              }
            }
            if (_msgHandlers[path] != null) {
              Function handler = _msgHandlers[path]!;
              handler(msg['data']);
            }
          } catch (_) {
            // ignore
          }
        },
        onLoadStop: (controller, url) async {
          print('onLoadStop: webview loaded');
          if (webViewLoaded) {
            return;
          }

          _handleReloaded();
          await _startJSCode();
        },
      );

      await _web!.run();
      print("LOAD URL");
      // ignore: unawaited_futures
      //_web!.webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://localhost:10001/nothing.html"))); // invalid URL test
      //_web!.webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://localhost:10001/")));
      // ignore: unawaited_futures
      await _loadHtmlFromAssets(_web!.webViewController);
      print("Done loading URL");
    } else {
      _webViewReloadTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        _tryReload();
      });
    }
  }

  Future<void> _loadHtmlFromAssets(InAppWebViewController controller) async {
    String fileText = await rootBundle.loadString('assets/polkadot/web/index.html');

    print("fileText $fileText");

    // ignore: unawaited_futures
    Uri dataUri = Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));

    print("data uri $dataUri");

    // ignore: unawaited_futures
    await controller.loadUrl(urlRequest: URLRequest(url: dataUri));
  }

  void _tryReload() {
    if (!webViewLoaded) {
      _web?.webViewController.reload();
    }
  }

  void _handleReloaded() {
    _webViewReloadTimer?.cancel();
    webViewLoaded = true;
  }

  // disabled, don't need this, also doesn't work reliably
  Future<void> _startLocalServer() async {
    final ByteData cert = await rootBundle.load("assets/polkadot/ssl/certificate.text");
    final ByteData keys = await rootBundle.load("assets/polkadot/ssl/keys.text");
    final security = SecurityContext()
      ..useCertificateChainBytes(cert.buffer.asInt8List())
      ..usePrivateKeyBytes(keys.buffer.asInt8List());
    // Serves the API at localhost:10001 by default
    final server = Jaguar(port: 10001, securityContext: security);
    server.addRoute(serveFlutterAssets());
    await server.serve(logRequests: false);
  }

  Future<void> _startJSCode() async {
    print("starting js code");
    // inject js file to webView
    await _web!.webViewController.evaluateJavascript(source: _jsCode);
    //await evalJavascript(_jsCode);

    _onLaunched!();
  }

  int getEvalJavascriptUID() {
    return _evalJavascriptUID++;
  }

  Future<dynamic> evalJavascript(
    String code, {
    bool wrapPromise = true,
    bool allowRepeat = true,
  }) async {
    // check if there's a same request loading
    if (!allowRepeat) {
      for (final String i in _msgCompleters.keys) {
        final String call = code.split('(')[0];
        if (i.contains(call)) {
          print('request $call loading');
          return _msgCompleters[i]!.future;
        }
      }
    }

    if (!wrapPromise) {
      final res = await _web!.webViewController.evaluateJavascript(source: code);
      return res;
    }

    final c = Completer();

    final uid = getEvalJavascriptUID();
    final method = 'uid=$uid;${code.split('(')[0]}';
    _msgCompleters[method] = c;

    final script = '''
      $code.then(function(res) {
          console.log(JSON.stringify({ path: "$method", data: res }));
        }).catch(function(err) {
          console.log(JSON.stringify({ path: "log", data: {call: "$method", error: err} }));
        });
        ''';
    await _web!.webViewController.evaluateJavascript(source: script);

    return c.future;
  }

  /// Connect to one of a list of nodes
  /// returns the node it connected to, or null if connection failed
  Future<NetworkParams?> connectNode(List<NetworkParams> nodes) async {
    final isAvatarSupport = (await evalJavascript('settings.connectAll ? {}:null', wrapPromise: false)) != null;
    final dynamic res = await (isAvatarSupport
        ? evalJavascript('settings.connectAll(${jsonEncode(nodes.map((e) => e.endpoint).toList())})')
        : evalJavascript('settings.connect(${jsonEncode(nodes.map((e) => e.endpoint).toList())})'));
    if (res != null) {
      final index = nodes.indexWhere((e) => e.endpoint!.trim() == res.trim());
      return nodes[index > -1 ? index : 0];
    }
    return null;
  }

  // Hashed Wallet API
  // Simple endpoint connect for single endpoint
  Future<String?> connectEndpoint(String endpoint) async {
    print("connect endpt");
    final res = await evalJavascript('settings.connect([$endpoint])');
    print("endpt connected");
    print(res);
    if (res != null) {
      return endpoint;
    } else {
      return null;
    }
  }

  Future<void> subscribeMessage(
    String code,
    String channel,
    Function callback,
  ) async {
    addMsgHandler(channel, callback);
    await evalJavascript(code);
  }

  void unsubscribeMessage(String channel) {
    print('unsubscribe $channel');
    final unsubCall = 'unsub$channel';
    _web!.webViewController.evaluateJavascript(source: 'window.$unsubCall && window.$unsubCall()');
  }

  void addMsgHandler(String channel, Function onMessage) {
    _msgHandlers[channel] = onMessage;
  }

  void removeMsgHandler(String channel) {
    _msgHandlers.remove(channel);
  }
}
