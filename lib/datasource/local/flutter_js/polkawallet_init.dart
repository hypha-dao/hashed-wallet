import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hashed/datasource/local/flutter_js/web_view_runner.dart';
import 'package:hashed/datasource/local/models/substrate_chain_model.dart';

/// This class packages all calls into the original Polkawallet API code
/// It isolates our app from the original Polkawallet code.
class PolkawalletInit {
  final nodeList = hashedNetworkParams;
  bool _connected = false;
  InAppWebViewController? get controller => webView.webViewController;
  WebViewRunner webView = WebViewRunner();
  bool get isConnected => _connected;
  SubstrateChainModel? connectedNode;
  bool _initialized = false;

  void Function(bool isConnected) connectionStateHandler;

  PolkawalletInit(this.connectionStateHandler);

  Future<void> init() async {
    print("PolkawalletInit init");

    final c = Completer();

    await webView.launch(
      () async {
        print("ON INITIATED...");
        c.complete();
      },
      socketDisconnectedAction: () {
        print("WARNING: socket disconnected action invoked");
      },
    );

    // OLD code - we try to remove the entire SKD except fot the web view runner
    // await WalletSDK().init(
    //   socketDisconnectedAction: () {
    //     print("WARNING: socket disconnected action invoked");
    //   },
    // );

    print("service.plugin.start ${nodeList.map((e) => e.endpoint)}");

    _initialized = true;

    return c.future;
  }

  Future<int?> connect() async {
    // if (!_initialized) {
    //   await init();
    // }

    /// Connect to a node
    final res = await webView.connectNode(nodeList);

    _connected = res?.endpoint != null;
    updateConnectionHandler();

    if (res == null) {
      return null;
    }

    connectedNode = res;

    print("connected: ${res.endpoint}");

    /// start up the reconnect service
    _dropsService(node: res);

    return 0;
  }

  Future<void> stop() async {
    _webViewDropsTimer?.cancel();
    _dropsServiceTimer?.cancel();
    _chainTimer?.cancel();
    await webView.evalJavascript('api.disconnect()');
    await webView.dispose();
    _initialized = false;
  }

  Timer? _webViewDropsTimer;
  Timer? _dropsServiceTimer;
  Timer? _chainTimer;
  // implementation of a reconnect service.
  // with three timers.
  void _dropsService({SubstrateChainModel? node}) {
    // every time this is called, all timers are canceled.
    _dropsServiceCancel();
    webView.evalJavascript('api.rpc.system.chain()').then((value) {
      print("Check 0: api.rpc.system.chain value: $value");
    });

    _dropsServiceTimer = Timer(const Duration(seconds: 24), () async {
      // after 24 seconds we create an 18 second timeout to reconnect, then make
      // a chain call.
      // if the chain call succeeds within 18 seconds, it cancels all timers and
      // starts over.
      // if the timer hits before the chain call succeeds, or the chain call fails,
      // then 18 seconds later we call _restartWebConnect.

      _chainTimer = Timer(const Duration(seconds: 18), () async {
        // if this succeeds within 60 seconds, we're reconnected.
        // if it fails or does not return in 60 seconds, we cancel all timers
        // and start over.
        // That's a little odd.
        // Note: I am pretty sure this code has bugs and race conditions.

        print("Connection dropped, restarting");
        unawaited(_restartWebConnect(node: node));

        _webViewDropsTimer = Timer(const Duration(seconds: 60), () {
          _dropsService(node: node);
        });
      });
      // TODO(n13): This is how we can just make all chain calls, and not worry about the "sdk" functions
      // ignore: unawaited_futures
      webView.evalJavascript('api.rpc.system.chain()').then((value) {
        print("api.rpc.system.chain value: $value");
        _dropsService(node: node);
      });
    });
  }

  Future<dynamic> evaluateJavascript({required String source, ContentWorld? contentWorld}) async {
    if (controller != null) {
      return controller!.evaluateJavascript(source: source);
    } else {
      print("Error: No controller, can't execute JS");
    }
  }

  void _dropsServiceCancel() {
    _dropsServiceTimer?.cancel();
    _chainTimer?.cancel();
    _webViewDropsTimer?.cancel();
  }

  void updateConnectionHandler() {
    connectionStateHandler(_connected);
  }

  Future<void> _restartWebConnect({SubstrateChainModel? node}) async {
    // TODO(n13): Dispose of the web view, and create new one
    _connected = false;
    updateConnectionHandler();

    final res = await webView.connectNode(nodeList);
    if (res != null) {
      _connected = true;
      updateConnectionHandler();

      print("COnnected: ${res.endpoint}");
      // setState(() {
      //   _connectedNode = connected;
      // });

      _dropsService(node: node);
    }
  }
}

late List<SubstrateChainModel> kusamaNetworkParams =
    nodeListKusama.map((e) => SubstrateChainModel.fromJson(e)).toList();
late List<SubstrateChainModel> polkadotNetworkParams =
    nodeListPolkadot.map((e) => SubstrateChainModel.fromJson(e)).toList();
late List<SubstrateChainModel> hashedNetworkParams =
    nodeListHashed.map((e) => SubstrateChainModel.fromJson(e)).toList();

const nodeListHashed = [
  {
    'name': 'Hashed N1',
    'ss58': 42,
    'endpoint': 'wss://n1.hashed.systems',
  }
];

const nodeListKusama = [
  {
    'name': 'Kusama (via PatractLabs)',
    'ss58': 2,
    'endpoint': 'wss://pub.elara.patract.io/kusama',
  },
  {
    'name': 'Kusama (via Parity)',
    'ss58': 2,
    'endpoint': 'wss://kusama-rpc.polkadot.io/',
  },
  {
    'name': 'Kusama (via OnFinality)',
    'ss58': 2,
    'endpoint': 'wss://kusama.api.onfinality.io/public-ws',
  },
  {
    'name': 'Kusama (via RadiumBlock)',
    'ss58': 2,
    'endpoint': 'wss://kusama.public.curie.radiumblock.co/ws',
  },
  {
    'name': 'Kusama (via Dwellir)',
    'ss58': 2,
    'endpoint': 'wss://kusama-rpc.dwellir.com',
  },
  // {
  //   'name': 'Kusama (cross chain 9110 dev)',
  //   'ss58': 42,
  //   'endpoint': 'wss://kusama-1.polkawallet.io:9944',
  // },
  // {
  //   'name': 'Kusama (cross chain 9100 dev)',
  //   'ss58': 42,
  //   'endpoint': 'wss://crosschain-dev.polkawallet.io:9906',
  // },
];
const nodeListPolkadot = [
  {
    'name': 'Polkadot (via PatractLabs)',
    'ss58': 0,
    'endpoint': 'wss://pub.elara.patract.io/polkadot',
  },
  {
    'name': 'Polkadot (via Parity)',
    'ss58': 0,
    'endpoint': 'wss://rpc.polkadot.io',
  },
  {
    'name': 'Polkadot (via OnFinality)',
    'ss58': 0,
    'endpoint': 'wss://polkadot.api.onfinality.io/public-ws',
  },
  {
    'name': 'Polkadot (via Dwellir)',
    'ss58': 0,
    'endpoint': 'wss://polkadot-rpc.dwellir.com',
  },
  // {
  //   'name': 'Polkadot (light client - experimental)',
  //   'ss58': 0,
  //   'endpoint': 'light://substrate-connect/polkadot',
  // },
  // {
  //   'name': 'Polkadot (aca crowdloan dev)',
  //   'ss58': 0,
  //   'endpoint': 'wss://karura-test-node.laminar.codes/polkadot',
  // },
];
