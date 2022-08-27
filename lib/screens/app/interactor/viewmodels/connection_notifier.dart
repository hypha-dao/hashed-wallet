// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart';

// class Endpoint {
//   final String url;
//   final int ping;

//   const Endpoint(this.url, this.ping);
// }

// const infinitePing = 1000000;
// const doubleInfinitePing = 2000000;

// class ConnectionNotifier extends ChangeNotifier {
//   bool status = true;

//   String currentEndpoint = '';
//   int? currentEndpointPing = 0;

//   final availableEndpoints = [
//     'https://mainnet.telosusa.io',
//     'https://telos.eosphere.io',
//     'https://telos.caleos.io',
//     'https://api.eos.miami',
//   ];

//   Future<void> discoverEndpoints() async {
//     final checks = <Future>[];

//     for (final endpoint in availableEndpoints) {
//       checks.add(checkEndpoint(endpoint));
//     }

//     final responses = await Future.wait(checks);

//     responses.sort((a, b) => a.ping - b.ping);

//     currentEndpoint = responses[0].url;
//     print('setting endpoint to ${responses[0].url}');
//     currentEndpointPing = responses[0].ping;
//     notifyListeners();
//   }

//   Future<Endpoint> checkEndpoint(String endpoint) async {
//     try {
//       final ping = Stopwatch()..start();
//       final res = await get(Uri.parse('$endpoint/v2/health'));
//       ping.stop();
//       if (res.statusCode == 200) {
//         final endpointPing = ping.elapsedMilliseconds;
//         return Endpoint(endpoint, endpointPing);
//       } else {
//         return Endpoint(endpoint, infinitePing);
//       }
//     } catch (err) {
//       print('error pinging: ${err.toString()}');
//       return Endpoint(endpoint, doubleInfinitePing);
//     }
//   }
// }
