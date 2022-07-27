import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('polkadot JS', () {
    test('load JS code', () async {
      DartPluginRegistrant.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });
  });
}
