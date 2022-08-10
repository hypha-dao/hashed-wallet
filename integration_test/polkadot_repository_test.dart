import 'package:flutter_test/flutter_test.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:integration_test/integration_test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/main.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // InAppLocalhostServer localhostServer = InAppLocalhostServer();
  // if (!localhostServer.isRunning()) {
  //   await localhostServer.start();
  // }

  final repository = PolkadotRepository();

  group('end-to-end test', () {
    testWidgets('Test polkadot repo', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await repository.initService();
      // known mnemonic, well, now it is - don't use it for funds
      const mnemonic = 'sample split bamboo west visual approve brain fox arch impact relief smile';
      // sr25519 ==> 5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA

      final res = repository.importKey(mnemonic);

      print(res);
    });
  });
}
