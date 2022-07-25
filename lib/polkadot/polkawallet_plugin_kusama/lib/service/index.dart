// ignore_for_file: prefer_initializing_formals, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:seeds/polkadot/polkawallet_plugin_kusama/lib/polkawallet_plugin_kusama.dart';
import 'package:seeds/polkadot/polkawallet_plugin_kusama/lib/service/gov.dart';
import 'package:seeds/polkadot/polkawallet_plugin_kusama/lib/service/staking.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/storage/keyring.dart';
import 'package:seeds/polkadot/sdk_0.4.8/lib/storage/types/keyPairData.dart';

class PluginApi {
  PluginApi(PluginKusama plugin, Keyring keyring)
      : staking = ApiStaking(plugin, keyring),
        gov = ApiGov(plugin, keyring),
        plugin = plugin;
  final ApiStaking staking;
  final ApiGov gov;

  final PluginKusama plugin;

  Future<String?> getPassword(BuildContext context, KeyPairData acc) async {
    final password = await showCupertinoDialog(
      context: context,
      builder: (_) {
        print("not implemented");
        return SizedBox();
        // return PasswordInputDialog(
        //   plugin.sdk.api,
        //   title: Text(I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!['unlock']!),
        //   account: acc,
        // );
      },
    );
    return password;
  }

  Future<String> getRuntimeModuleName(List<String> modules) async {
    final res = await Future.wait(modules
        .map((e) => plugin.sdk.webView!.evalJavascript('(api.tx.$e != undefined ? {} : null)', wrapPromise: false)));
    print(res);
    return modules[res.indexWhere((e) => e != null)];
  }
}
