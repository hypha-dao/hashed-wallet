import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hashed/datasource/local/flutter_js/web_view_runner.dart';
import 'package:hashed/datasource/local/models/substrate_chain_model.dart';

/// This class packages all calls into the original Polkawallet API code
/// It isolates our app from the original Polkawallet code.
class SubstrateService {
  final nodeList = hashedNetworkParams;
  bool _connected = false;
  InAppWebViewController? get controller => webView.webViewController;
  WebViewRunner webView = WebViewRunner();
  bool get isConnected => _connected;
  SubstrateChainModel? connectedNode;
  bool _initialized = false;

  void Function(bool isConnected)? connectionStateHandler;

  SubstrateService(this.connectionStateHandler);

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

    print("Substrate service initialized ${nodeList.map((e) => e.endpoint)}");

    _initialized = true;

    return c.future;
  }

  Future<int?> connect() async {
    if (!_initialized) {
      throw "you have to initialize the service before connecting";
    }

    /// Connect to a node
    final res = await webView.connectNode(nodeList);

    _connected = res?.endpoint != null;
    connectionStateHandler?.call(_connected);

    if (res == null) {
      return null;
    }

    connectedNode = res;

    print("connected: ${res.endpoint}");

    /// start up the reconnect service
    startKeepAliveTimer();

    return 0;
  }

  Future<void> stop() async {
    print("STOP SERVICE");
    _keepAliveTimer?.cancel();
    try {
      await webView.evalJavascript('api.disconnect()');
    } catch (error) {
      print("api stop fail $error");
    }
    await webView.dispose();
    webView = WebViewRunner();
    _initialized = false;
  }

  DateTime? _lastCheck;
  Timer? _keepAliveTimer;
  final int _aliveSeconds = 18;

  /// Keep alive timer accurately reports when the connection is down
  /// It does not take actions other than calling the connectionStateHandler
  void startKeepAliveTimer() {
    _keepAliveTimer = Timer(const Duration(seconds: 6), () async {
      final aliveCheckSuccess = await _runAliveCheck();
      if (aliveCheckSuccess) {
        _lastCheck = DateTime.now();
      } else {
        /// Alive check failed - we ignore a certain number of failed alive checks
        if (_lastCheck != null) {
          if (DateTime.now().difference(_lastCheck!).inSeconds > _aliveSeconds) {
            print("Network is disconnected");
            _keepAliveTimer?.cancel();
            _lastCheck = null;
            _connected = false;
            connectionStateHandler?.call(false);
          } else {
            print("disconnect detected at ${DateTime.now()} - ignoring...");
          }
        }
      }
    });
  }

  Future<bool> _runAliveCheck() async {
    final res = await webView.evalJavascript('api.rpc.system.chain()');
    if (res == null) {
      print("Alive check fail at ${DateTime.now()}");
      return false;
    } else {
      return true;
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

final List<SubstrateChainModel> kusamaNetworkParams =
    nodeListKusama.map((e) => SubstrateChainModel.fromJson(e)).toList();
final List<SubstrateChainModel> polkadotNetworkParams =
    nodeListPolkadot.map((e) => SubstrateChainModel.fromJson(e)).toList();
final List<SubstrateChainModel> hashedNetworkParams =
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
