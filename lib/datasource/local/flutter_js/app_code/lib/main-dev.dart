// // @dart=2.9
// import 'package:seeds/datasource/local/flutter_js/app_code/lib/app.dart';
// import 'package:seeds/datasource/local/flutter_js/app_code/lib/common/consts.dart';
// import 'package:seeds/datasource/local/flutter_js/app_code/lib/common/types/pluginDisabled.dart';
// import 'package:seeds/datasource/local/flutter_js/app_code/lib/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_bugly/flutter_bugly.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:polkawallet_plugin_acala/polkawallet_plugin_acala.dart';
// import 'package:polkawallet_plugin_bifrost/polkawallet_plugin_bifrost.dart';
// import 'package:polkawallet_plugin_edgeware/polkawallet_plugin_edgeware.dart';
// import 'package:polkawallet_plugin_karura/polkawallet_plugin_karura.dart';
// import 'package:polkawallet_plugin_kusama/polkawallet_plugin_kusama.dart';
// import 'package:polkawallet_plugin_statemine/polkawallet_plugin_statemine.dart';
// import 'package:polkawallet_plugin_dbc/polkawallet_plugin_dbc.dart';

// void main() async {
//   // FlutterBugly.postCatchedException(() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   await GetStorage.init(get_storage_container);
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   final plugins = [
//     PluginKusama(name: 'polkadot'),
//     PluginKusama(),
//     PluginAcala(),
//     PluginKarura(),
//     PluginStatemine(),
//     PluginBifrost(),
//     // PluginChainX(),
//     PluginEdgeware(),
//     // PluginLaminar(),
//     PluginDBC(),
//   ];

//   runApp(WalletApp(
//       plugins, [PluginDisabled('chainx', Image.asset('assets/images/public/chainx_gray.png'))], BuildTargets.dev));
//   //   FlutterBugly.init(
//   //     androidAppId: "64c2d01918",
//   //     iOSAppId: "3803dd717e",
//   //   );
//   // });
// }
