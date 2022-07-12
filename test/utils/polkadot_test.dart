import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('polkadot JS', () {
    test('load JS code', () async {
      DartPluginRegistrant.ensureInitialized();

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
