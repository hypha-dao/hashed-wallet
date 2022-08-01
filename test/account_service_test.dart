import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/local/models/account.dart';

class MockSettingsStorage extends AbstractStorage {
  String? _accounts;
  String? _currentAccount;
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

  @override
  String? get currentAccount => _currentAccount;
}

class MockKeyRepository extends KeyRepository {
  @override
  Future<String?> publicKeyForPrivateKey(String privateKey) {
    return Future.delayed(Duration.zero, () => "publicOf$privateKey");
  }
}

final mockAccount1 = const Account(address: "0x011", name: "one");
final mockAccount2 = const Account(address: "0x012", name: "two");
final mockAccount3 = const Account(address: "0x013", name: "three, with a comm, a }{{{");
final mockAccount4 = const Account(address: "0x014", name: 'four with quote and emoji character ❤️ "[ { , . 2');

// known mnemonic, well, now it is - don't use it for funds
const mnemonic1 = 'sample split bamboo west visual approve brain fox arch impact relief smile';
// mnemonic1 as sr25519 ==> 5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA
const mnemonic2 = 'not a real mnemonic but should work';
const mnemonic3 = '0x12345677890123454567890';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Test loadAccounts saveAccounts', () async {
    final service = AccountService(MockSettingsStorage(), MockKeyRepository());

    final initialAccts = service.loadAccounts();

    assert(initialAccts.isEmpty, "initialAccts wrong $initialAccts");

    service.saveAccounts([mockAccount1]);
    final accts1 = service.loadAccounts();
    assert(accts1.length == 1, "accts1 length wrong");
    assert(accts1[0] == mockAccount1, "accts1 wrong value");

    service.saveAccounts([mockAccount2, mockAccount3]);
    final accts2 = service.loadAccounts();
    assert(accts2.length == 2, "accts2 length wrong");
    assert(accts2[0] == mockAccount2, "accts2 wrong value");
    assert(accts2[1] == mockAccount3, "accts2 wrong value");

    service.saveAccounts([mockAccount4, mockAccount3, mockAccount2, mockAccount1]);
    final accts3 = service.loadAccounts();
    assert(accts3.length == 4, "accts3 length wrong");
    assert(accts3[0] == mockAccount4, "accts3 wrong value ${accts2[0]}");
    assert(accts3[3] == mockAccount1, "accts3 wrong value");
  });
  test('Test createAccount', () async {
    final service = AccountService(MockSettingsStorage(), MockKeyRepository());

    final name = 'Harry "The Hammer" Lockstone';
    await service.createAccount(name: name, privateKey: mnemonic1);

    final accts1 = service.loadAccounts();
    final pks1 = await service.getPrivateKeys();

    assert(accts1.length == 1, "accts1 wrong");
    assert(accts1[0].name == name, "accts1 wrong ${accts1[0].name}");
    assert(accts1[0].address.isNotEmpty, "accts1 wrong");

    assert(pks1.length == 1, "pks1 length wrong");
    assert(pks1[0] == mnemonic1, "pks1 wrong value");
  });
  test('Test getPrivateKeys, savePrivateKeys', () async {
    final service = AccountService(MockSettingsStorage(), MockKeyRepository());
    final initialPks = await service.getPrivateKeys();

    assert(initialPks.isEmpty, "initialPks wrong");

    await service.savePrivateKeys([mnemonic1]);
    final pks1 = await service.getPrivateKeys();
    assert(pks1.length == 1, "pks1 length wrong");
    assert(pks1[0] == mnemonic1, "pks1 wrong value");

    await service.savePrivateKeys([mnemonic1, mnemonic2, mnemonic3]);
    final pks2 = await service.getPrivateKeys();
    assert(pks2.length == 3, "pks2 length wrong");
    assert(pks2[0] == mnemonic1, "pks2 wrong value");
    assert(pks2[1] == mnemonic2, "pks2 wrong value");
    assert(pks2[2] == mnemonic3, "pks2 wrong value");
  });
}
