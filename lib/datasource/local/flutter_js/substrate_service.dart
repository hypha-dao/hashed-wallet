import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hashed/datasource/local/flutter_js/web_view_runner.dart';
import 'package:hashed/datasource/local/models/substrate_chain_model_old.dart';
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

final List<SubstrateChainModelOld> kusamaNetworkParams =
    nodeListKusama.map((e) => SubstrateChainModelOld.fromJson(e)).toList();
final List<SubstrateChainModelOld> polkadotNetworkParams =
    nodeListPolkadot.map((e) => SubstrateChainModelOld.fromJson(e)).toList();
final List<SubstrateChainModelOld> hashedNetworkParams =
    nodeListHashed.map((e) => SubstrateChainModelOld.fromJson(e)).toList();

const nodeListHashed = [
  {
    "info": "hashed",
    "paraId": 1440, // fake..
    "text": "Hashed Network",
    'ss58': 42,
    "providers": {
      "N1 Node": "wss://n1.hashed.systems",
    }
  },
  // {
  //   'name': 'Hashed N1',
  //   'ss58': 42,
  //   'endpoint': 'wss://n1.hashed.systems',
  // }
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
