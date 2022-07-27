import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/local/flutter_js/polkawallet_init.dart';

class MockSettingsStorage extends AbstractStorage {
  String? _accounts;
  String? _privateKeys;

  @override
  String? get accounts => _accounts;

  @override
  void saveAccounts(String jsonFromList) {
    _accounts = jsonFromList;
  }

  @override
  Future<String?> getPrivateKeysString() async {
    return Future.delayed(Duration.zero, () => _privateKeys);
  }

  @override
  Future<void> savePrivateKeys(String privateKeysJsonString) async {
    _privateKeys = privateKeysJsonString;
  }
}

void main() {
  AbstractStorage? storage;
  PolkawalletInit? polkadotInit;

  setUp(() {
    storage = MockSettingsStorage();
    polkadotInit = PolkawalletInit();
  });

  test('Test something', () async {
    await polkadotInit!.init();
    // known mnemonic, well, now it is - don't use it for funds
    const mnemonic = 'sample split bamboo west visual approve brain fox arch impact relief smile';
    // sr25519 ==> 5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA

    const res = 

  });
}
