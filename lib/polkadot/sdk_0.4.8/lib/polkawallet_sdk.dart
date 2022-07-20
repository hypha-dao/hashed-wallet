library polkawallet_sdk;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/api/api.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/service/index.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/service/webViewRunner.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/storage/keyring.dart';

/// SDK launchs a hidden webView to run polkadot.js/api for interacting
/// with the substrate-based block-chain network.
class WalletSDK {
  late PolkawalletApi api;

  List<String> _blackList = [];

  get blackList => _blackList;

  final _service = SubstrateService();

  /// webView instance, this is the only instance of FlutterWebViewPlugin
  /// in App, we need to get it and reuse in other sdk.
  WebViewRunner? get webView => _service.webView;

  /// param [jsCode] is customized js code of parachain,
  /// the api works without [jsCode] param in Kusama/Polkadot.
  Future<void> init(
    Keyring keyring, {
    WebViewRunner? webView,
    String? jsCode,
    Function? socketDisconnectedAction,
  }) async {
    final c = Completer();

    await _service.init(
      keyring,
      webViewParam: webView,
      jsCode: jsCode,
      socketDisconnectedAction: socketDisconnectedAction,
      onInitiated: () {
        // inject keyPairs after webView launched
        _service.keyring.injectKeyPairsToWebView(keyring);

        // and initiate pubKeyIconsMap
        api.keyring.updatePubKeyIconsMap(keyring);

        _updateBlackList();

        if (!c.isCompleted) {
          c.complete();
        }
      },
    );

    api = PolkawalletApi(_service);
    return c.future;
  }

  Future<void> _updateBlackList() async {
    try {
      Response res =
          await get(Uri.parse('https://polkadot.js.org/phishing/address.json'));
      if (res.body.isNotEmpty) {
        final data = jsonDecode(res.body) as Map;
        final List<String> list = [];
        data.values.forEach((e) {
          list.addAll(List<String>.from(e));
        });
        final pubKeys = await api.account.decodeAddress(list);
        if (pubKeys != null) {
          _blackList = List<String>.from(pubKeys.keys.toList());
        }
      }
    } catch (err) {
      print(err);
    }
  }
}
