import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';

void main() {
  PolkadotRepository? repository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    repository = PolkadotRepository();
  });

  test('Test something', () async {
    await repository!.initService();
    // known mnemonic, well, now it is - don't use it for funds
    const mnemonic = 'sample split bamboo west visual approve brain fox arch impact relief smile';
    // sr25519 ==> 5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA

    final res = repository!.importKey(mnemonic);

    print(res);
  });
}
