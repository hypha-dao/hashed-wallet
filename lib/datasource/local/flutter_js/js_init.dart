import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class JSInit {
  final JavascriptRuntime runtime = getJavascriptRuntime();
  // factory JSInit() {
  //   return _instance;
  // }
  // JSInit._privateConstructor(this.runtime);

  // static final JSInit _instance = JSInit._privateConstructor(getJavascriptRuntime());

  Future<void> init() async {
    try {
      print("LLLLL");
      JavascriptRuntime.debugEnabled = true;
      final String code = await rootBundle.loadString('assets/polkadot/polkajs.bundle.js');

      print("loading bundle ${code.length / 1000.0}");

      //runtime.evaluate("""var window = global = globalThis;""");

      // ignore: prefer_interpolation_to_compose_strings
      runtime.evaluate(code + "");

      // call to init can be made into a parameterized "connect" api function
      final res = await runtime.evaluateAsync('''
      service.init({
        endpoint: "wss://n1.hashed.systems"
      })
    ''');
      print("init done ");
      print(res);
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }
}
