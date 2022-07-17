import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class JSInit {
  JavascriptRuntime runtime = getJavascriptRuntime();

  // bundle-polkadot-util.js
  String testPolkadotUtil = """
      console.log('polkadotUtil');

      const { bnToBn, u8aToHex } = polkadotUtil;

      console.log('u8aToHex', u8aToHex(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8])));
    """;

  Future<void> init() async {
    try {
      // reset runtime for debugging...
      runtime.dispose();
      runtime = getJavascriptRuntime();

      JavascriptRuntime.debugEnabled = true;

      final String polkadotUtilBundle = await rootBundle.loadString('assets/polkadot/bundles/bundle-polkadot-util.js');

      // final r0 = runtime.evaluate(""" // this doesn't help
      //   var window = {};
      //   var globalThis = window;
      // """);
      // print("eval r0:");
      // print(r0);

      print("loading polkadotUtilBundle ${polkadotUtilBundle.length / 1000.0}");
      // final r1 = await runtime.evaluate(polkadotUtilBundle);
      final r1 = await runtime.evaluateAsync(polkadotUtilBundle);
      print("eval res:");
      print(r1);

      print(runtime.evaluate(testPolkadotUtil));

//       runtime.evaluate("""
// console.log("show svc: "+service);
// console.log("show svc: "+service.init);
// service.init("wss://ournode.hashed.io");
//       """);

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
