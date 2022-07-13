import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('polkadot JS', () {
    test('load JS code', () async {
      DartPluginRegistrant.ensureInitialized();
      SharedPreferences.setMockInitialValues({});

// Note there's a init dependency that makes this test case fail
// doing the below not working since the library generates random name
// channels... so we can't override them here.

      // const MethodChannel('com.pichillilorenzo/flutter_headless_inappwebview')
      //     .setMockMethodCallHandler((MethodCall methodCall) async {
      //   if (methodCall.method == 'run') {
      //     print("run called");
      //     return <String, dynamic>{}; // set initial values here if desired
      //   } else if (methodCall.method == 'evaluateJavascript') {
      //     print("evaluateJavascript called");
      //     return <String, dynamic>{}; // set initial values here if desired
      //   }
      //   return null;
      // });

      final service = SubstrateService();
      final keyRing = Keyring();
      await service.init(keyRing, onInitiated: () => {print("initiated.")});

      final controller = service.webView!.web?.webViewController;

      final res1 = await controller?.evaluateJavascript(source: '1 + 4');
      print(res1.runtimeType); // int
      print(res1);

      final res = await service.webView!.evalJavascript('1 + 1');
      print(res);

      expect(res, 2);
    });
  });
}
