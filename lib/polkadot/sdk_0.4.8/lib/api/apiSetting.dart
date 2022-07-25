// ignore_for_file: unawaited_futures, unnecessary_nullable_for_final_variable_declarations

import 'package:seeds/polkadot/sdk_0.4.8/lib/api/api.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/api/types/networkStateData.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/service/setting.dart';

class ApiSetting {
  ApiSetting(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceSetting? service;

  final _msgChannel = "BestNumber";

  /// query network const.
  Future<Map?> queryNetworkConst() async {
    final Map? res = await service!.queryNetworkConst();
    return res;
  }

  /// query network properties.
  Future<NetworkStateData?> queryNetworkProps() async {
    final Map? res = await service!.queryNetworkProps();
    if (res == null) {
      return null;
    }
    return NetworkStateData.fromJson(res as Map<String, dynamic>);
  }

  /// subscribe best number.
  /// @return [String] msgChannel, call unsubscribeMessage(msgChannel) to unsub.
  Future<void> subscribeBestNumber(Function callback) async {
    apiRoot.subscribeMessage(
      'api.derive.chain.bestNumber',
      [],
      _msgChannel,
      callback,
    );
  }

  Future<void> unsubscribeBestNumber() async {
    apiRoot.service.webView!.unsubscribeMessage(_msgChannel);
  }
}
