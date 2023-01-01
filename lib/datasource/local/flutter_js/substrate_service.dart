import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hashed/datasource/local/flutter_js/web_view_runner.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';

/// This class packages all calls into the original Polkawallet API code
/// It isolates our app from the original Polkawallet code.
class SubstrateService {
  final NetworkData network;
  bool _connected = false;
  InAppWebViewController? get controller => webView.webViewController;
  WebViewRunner webView = WebViewRunner();
  bool get isConnected => _connected;
  String? connectedNode;
  bool _initialized = false;

  SubstrateService(this.network);

  Future<void> init() async {
    print("PolkawalletInit init");

    final c = Completer();

    await webView.launch(
      () async {
        print("ON INITIATED...");
        c.complete();
      },
      // socketDisconnectedAction: () {
      //   print("WARNING: socket disconnected action invoked");
      // },
    );

    print("Substrate service initialized ${network.name}: ${network.endpoints}");

    _initialized = true;

    return c.future;
  }

  Future<bool> connect() async {
    try {
      print("Substrate Service: CONNECT");
      if (!_initialized) {
        throw "you have to initialize the service before connecting";
      }

      /// Connect to a node
      final res = await webView.connectNode(network).timeout(const Duration(seconds: 30));

      _connected = res != null;

      connectedNode = res;

      print("connected: $_connected");

      return _connected;
    } catch (error) {
      print("connection failed with exception: $error");
      _connected = false;
      return false;
    }
  }

  Future<void> stop() async {
    print("STOP SERVICE");
    try {
      await webView.evalJavascript('api.disconnect()');
    } catch (error) {
      print("api stop fail $error");
    }
    await webView.dispose();
    _initialized = false;
  }

  Future<bool> runAliveCheck() async {
    try {
      final future = webView.evalJavascript('api.rpc.system.chain()');

      /// manually time out after 4 seconds - the webView has a 60+ seconds timeout
      /// this means it does not return in time.
      final res = await future.timeout(const Duration(seconds: 4));
      //print("alive check result: $res");
      if (res == null) {
        print("Alive check fail at ${DateTime.now()}");
        return false;
      } else {
        return true;
      }
    } catch (error) {
      print("alive check error: $error");
      return false;
    }
  }

  Future<dynamic> evaluateJavascript({required String source, ContentWorld? contentWorld}) async {
    if (controller != null) {
      return controller!.evaluateJavascript(source: source);
    } else {
      print("Error: No controller, can't execute JS");
    }
  }
}
