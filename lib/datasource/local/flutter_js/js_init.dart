import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class JSInit {
  JavascriptRuntime runtime = getJavascriptRuntime();

  Future<void> init() async {
    try {
      runtime = getJavascriptRuntime();

      JavascriptRuntime.debugEnabled = true;

      // final String code = await rootBundle.loadString('assets/polkadot/js1.js');
      final String code = await rootBundle.loadString('assets/polkadot/main.js');
      //final String code = await rootBundle.loadString('assets/polkadot/polkajs.bundle.js');

      print("loading bundle ${code.length / 1000.0}");

      //runtime.evaluate("""var window = global = globalThis;""");

      //print("loaded code: $code");

      // ignore: prefer_interpolation_to_compose_strings
      final r1 = runtime.evaluate(code + "");
      print("eval res:");
      print(r1);

      runtime.evaluate("""
console.log("show svc: "+service);
console.log("show svc: "+service.init);
service.init("wss://ournode.hashed.io");
      """);

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
      // final rruleIsLoaded = runtime.evaluate('''
      //   var loaded = (typeof polka == 'undefined') ?
      //   "0" : "1"; loaded;
      //   ''').stringResult;
      // print("code is Loaded $rruleIsLoaded");

      //   final res = await runtime.evaluateAsync('''
      //     // import { ApiPromise, WsProvider } from "@polkadot/api";
      //     // const { Keyring } = require("@polkadot/keyring");

      //     console.log("global "+ globalThis);
      //     //console.log("XX "+ polka);

      //     // provider = new globalThis.WsProvider("wss://n1.hashed.systems");

      //     // var keys = Object.keys( global );
      //     //keys.forEach((k) => console.log(k + ":" + JSON.stringify(global[k], null, 2)));

      //     console.log("window keys: "+JSON.stringify(Object.keys( globalThis ), null, 2));

      //     // console.log("service: "+this.service);
      // ''');
      //   print("init done ");
      //   print("result: $res");

    } catch (err) {
      print("Error: $err");
      rethrow;
    }
  }
}
