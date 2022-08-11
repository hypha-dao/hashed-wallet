import 'dart:async';

import 'package:hashed/polkadot/sdk_0.4.8/lib/service/index.dart';

class ServiceParachain {
  ServiceParachain(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<Map?> queryParasOverview() async {
    final res = await serviceRoot.webView!.evalJavascript('parachain.queryParasOverview(api)') as Map?;
    return res;
  }

  Future<Map?> queryAuctionWithWinners() async {
    final res = await serviceRoot.webView!.evalJavascript('parachain.queryAuctionWithWinners(api)') as Map?;
    return res;
  }

  Future<List<String>> queryUserContributions(List<String> paraIds, String pubKey) async {
    final res = await serviceRoot.webView!.evalJavascript('Promise.all(['
        '${paraIds.map((e) => 'parachain.queryUserContributions(api, "$e", "$pubKey")').join(',')}])');
    return List<String>.from(res);
  }
}
