// _startApp
// _startPlugin

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_acala/polkawallet_plugin_acala.dart';
import 'package:polkawallet_plugin_bifrost/polkawallet_plugin_bifrost.dart';
import 'package:polkawallet_plugin_chainx/polkawallet_plugin_chainx.dart';
import 'package:polkawallet_plugin_dbc/polkawallet_plugin_dbc.dart';
import 'package:polkawallet_plugin_edgeware/polkawallet_plugin_edgeware.dart';
import 'package:polkawallet_plugin_karura/polkawallet_plugin_karura.dart';
import 'package:polkawallet_plugin_kusama/polkawallet_plugin_kusama.dart';
import 'package:polkawallet_plugin_robonomics/polkawallet_plugin_robonomics.dart';
import 'package:polkawallet_plugin_statemine/polkawallet_plugin_statemine.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/HeadlessApp.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/app.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/common/consts.dart';

class PolkawalletInit {
  HeadlessWalletApp? _app;
  WalletAppState? _appState;
  Future<void> init() async {
    // this is the start point
    print("init polka wallet..");
    final plugins = [
      PluginKusama(name: 'polkadot'),
      PluginKusama(),
      PluginAcala(),
      PluginKarura(),
      PluginStatemine(),
      PluginBifrost(),
      PluginChainX(),
      PluginEdgeware(),
      // PluginLaminar(),
      PluginDBC(),
      PluginRobonomics(),
    ];

    _app = HeadlessWalletApp(
        plugins,
        [
          // PluginDisabled(
          //     'chainx', Image.asset('assets/images/public/chainx_gray.png'))
        ],
        BuildTargets.apk);

    _app!.initState();
    await _app!.startAppExternal();

    // _appState!.widget = _app!;
  }
}
