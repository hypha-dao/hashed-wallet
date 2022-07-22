// _startApp
// _startPlugin

import 'dart:async';

import 'package:seeds/polkadot/polkawallet_plugin_kusama/lib/polkawallet_plugin_kusama.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/api/types/networkParams.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/plugin/index.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/polkawallet_sdk.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/storage/keyring.dart';

class AppService {
  PolkawalletPlugin plugin;
  AppService(this.plugin);
}

class PolkawalletInit {
  Keyring? _keyring;
  WalletSDK walletSdk = WalletSDK();

  final plugins = [
    PluginKusama(name: 'polkadot'),
    PluginKusama(),
  ];

  // from App _startApp
  Future<int> startApp() async {
    // ignore: prefer_conditional_assignment
    if (_keyring == null) {
      _keyring = Keyring();
    }

    print("startApp");
// initialize the keyring with "ss58" account types - ss58 variable here is an integer denoting the
// account type, for example "42" for a generic account type.
// We init the keyring class with account types here. It's converted to set to make the types unique.
// we don't need this, we only have one account type, 42.

    await _keyring?.init([0, 2, 42]); // 42 - generic substrate chain, 2 - kusama, 0 - polkadot

    print("PluginKusama");

    final PolkawalletPlugin plugin = PluginKusama(name: 'polkadot');
    // final allPlugins = [plugin];
    final currentPlugin = plugin;

    // service.init - doesn't do much - removed
    // final service = AppService(allPlugins, currentPlugin, _keyring, store);
    // service.init();
    // setState(() {
    //   _store = store;
    //   _service = service;
    // });

    print("AppService");
    final service = AppService(currentPlugin);

    // pretty much the only thing the plugin does in this is to call init on the SDK
    // Each plugin has their own SDK which makes sense.

    print("beforeStart");

    await currentPlugin.beforeStart(
      _keyring!,
      // ignore: avoid_redundant_argument_values
      jsCode: null,
      socketDisconnectedAction: () {
        print("WARNING: socket disconnected action invoked");
        // UI.throttle(() {
        //   _dropsServiceCancel();
        //   _restartWebConnect(service);
        // });
      },
    );

    // Possibly inline the above with this
    // await walletSdk.init(
    //   _keyring!,
    //   socketDisconnectedAction: () {
    //     print("WARNING: socket disconnected action invoked");
    //     // UI.throttle(() {
    //     //   _dropsServiceCancel();
    //     //   _restartWebConnect(service);
    //     // });
    //   },
    // );

// loading keyrings from storage - we should not need this
    // if (_keyring!.keyPairs.length > 0) {
    //   _store.assets.loadCache(_keyring.current, _service.plugin.basic.name);
    // }

// payload - we need this
    // ignore: unawaited_futures
    print("_startPlugin");

    // ignore: unawaited_futures
    _startPlugin(service);

    // WalletApi.getTokenStakingConfig().then((value) {
    //   _store.settings.setTokenStakingConfig(value);
    // });

    return _keyring!.allAccounts.length;
  }

  Future<void> _startPlugin(AppService service, {NetworkParams? node}) async {
    // plugin start connects the api
    print("service.plugin.start ${service.plugin.nodeList}");

    final connected = await service.plugin.start(_keyring!, nodes: node != null ? [node] : service.plugin.nodeList);

    print("connected: ${connected?.endpoint}");

    _dropsService(service, node: node);
  }

  Timer? _webViewDropsTimer;
  Timer? _dropsServiceTimer;
  Timer? _chainTimer;
  // implementation of a reconnect service.
  // with three timers.
  // wot.
  void _dropsService(AppService service, {NetworkParams? node}) {
    // every time this is called, all timers are canceled.
    _dropsServiceCancel();

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
        // Note: I am pretty sure this code has many bugs and race conditions.
        unawaited(_restartWebConnect(service, node: node));
        _webViewDropsTimer = Timer(const Duration(seconds: 60), () {
          _dropsService(service, node: node);
        });
      });
      // TODO(n13): This is how we can just make all chain calls, and not worry about the "sdk" functions
      // ignore: unawaited_futures
      service.plugin.sdk.webView?.evalJavascript('api.rpc.system.chain()').then((value) {
        print("api.rpc.system.chain value: $value");
        _dropsService(service, node: node);
      });
    });
  }

  void _dropsServiceCancel() {
    _dropsServiceTimer?.cancel();
    _chainTimer?.cancel();
    _webViewDropsTimer?.cancel();
  }

  Future<void> _restartWebConnect(AppService service, {NetworkParams? node}) async {
    // setState(() {
    //   _connectedNode = null;
    // });

    // Offline JS interaction will be affected (import and export accounts)
    // final useLocalJS = WalletApi.getPolkadotJSVersion(
    //       _store.storage,
    //       service.plugin.basic.name,
    //       service.plugin.basic.jsCodeVersion,
    //     ) >
    //     service.plugin.basic.jsCodeVersion;

    // await service.plugin.beforeStart(
    //   _keyring,
    //   webView: _service?.plugin?.sdk?.webView,
    //   jsCode: useLocalJS
    //       ? WalletApi.getPolkadotJSCode(
    //           _store.storage, service.plugin.basic.name)
    //       : null,
    // );

    final connected = await service.plugin.start(_keyring!, nodes: node != null ? [node] : service.plugin.nodeList);

    print("COnnected: $connected");
    // setState(() {
    //   _connectedNode = connected;
    // });

    _dropsService(service, node: node);
  }
}
