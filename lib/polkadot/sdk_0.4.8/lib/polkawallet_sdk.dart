// ignore_for_file: unused_import

library polkawallet_sdk;

import 'dart:async';
import 'dart:convert';

import 'package:hashed/polkadot/sdk_0.4.8/lib/api/api.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/index.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/webViewRunner.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/storage/keyring.dart';
import 'package:http/http.dart';

/// SDK launchs a hidden webView to run polkadot.js/api for interacting
/// with the substrate-based block-chain network.
class WalletSDK {
  // The api has a bunch of things we don't need, and the service, which has
  // the web view runner which we need
  // We also need the list of nodes but we have that elsewhere.
  // => extract web view, dump api.
  late PolkawalletApi api;

  // Service has a bunch of stuff we won't use, and the web view runner which we use
  // => extract the web view runner from that class, and dump it
  final _service = SubstrateService();

  // List<String> _blackList = [];

  // get blackList => _blackList;

  /// webView instance, this is the only instance of FlutterWebViewPlugin
  /// in App, we need to get it and reuse in other sdk.
  WebViewRunner? get webView => _service.webView;

  /// param [jsCode] is customized js code of parachain,
  /// the api works without [jsCode] param in Kusama/Polkadot.
  Future<void> init({
    Function? socketDisconnectedAction,
  }) async {
    final c = Completer();

    await _service.init(
      socketDisconnectedAction: socketDisconnectedAction,
      onInitiated: () async {
        final keyring = Keyring();
        await keyring.init([0, 2, 42]); // 42 - generic substrate chain, 2 - kusama, 0 - polkadot

        // inject keyPairs after webView launched
        // we need to do this - but don't need this class for it.
        await _service.keyring.injectKeyPairsToWebView(keyring);

        // and initiate pubKeyIconsMap
        // we don't use ucons - Nik
        //await api.keyring.updatePubKeyIconsMap(keyring);

        // _updateBlackList();

        if (!c.isCompleted) {
          c.complete();
        }
      },
    );

    api = PolkawalletApi(_service);
    return c.future;
  }
}
