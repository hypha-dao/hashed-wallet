import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class JSInit {
  final JavascriptRuntime runtime = getJavascriptRuntime();

  Future<void> init() async {
    try {
      print("LLLLL");
      JavascriptRuntime.debugEnabled = true;
      final String code = await rootBundle.loadString('assets/polkadot/polkajs.bundle.js');

      print("loading bundle ${code.length / 1000.0}");

      //runtime.evaluate("""var window = global = globalThis;""");

      // ignore: prefer_interpolation_to_compose_strings
      runtime.evaluate(code + "");

// this works perfectly
      //   print("res1 start");
      //   final res1 = runtime.evaluate('''
      //   const init = ({endpoint}) => {
      //     console.log("mock JS CONSOLE init"+endpoint);
      //   };
      //   const service = {
      //     init
      //   }
      // ''');
      //   print(res1);

      //this.polka.service.init({
      //  endpoint: "wss://n1.hashed.systems"
      //});

      // call to init can be made into a parameterized "connect" api function
      final res = await runtime.evaluateAsync('''

        console.log("keys: "+Object.keys( this ));

        console.log("service: "+this);
    ''');
      print("init done ");
      print("result: $res");
    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }
}
