import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/datasource/local/settings_storage.dart';

abstract class AbstractStorage {
  String? get accounts;

  void saveAccounts(String jsonFromList);

  Future<String?> getPrivateKeysString();

  Future<void> savePrivateKeys(String privateKeysJsonString);
}
class AccountService {
  final AbstractStorage storage;

  AccountService(this.storage);

  factory AccountService.instance() => AccountService(settingsStorage);

  Future<List<Account>> loadAccounts() async {
    final accountString = storage.accounts ?? "[]";
    return Account.listFromJson(accountString);
  }

  void saveAccounts(List<Account> accounts) {
    storage.saveAccounts(Account.jsonFromList(accounts));
  }

  Future<Account?> createAccount(String name, String privateKey) async {
    if (privateKey.contains(",")) {
      throw ArgumentError("illegal character in private key: ',': $privateKey");
    }
    Account? result;
    final public = await publicKeyForPrivateKey(privateKey);
    if (public != null) {
      final account = Account(name, public);
      final accounts = await loadAccounts();
      if (!accounts.contains(account)) {
        accounts.add(account);
        saveAccounts(accounts);
        result = account;
      }
      final privateKeys = await getPrivateKeys();
      if (!privateKeys.contains(privateKey)) {
        privateKeys.add(privateKey);
        await savePrivateKeys(privateKeys);
      }
    }
    return result;
  }

  Future<String?> publicKeyForPrivateKey(String privateKey) async {
    // TODO(n13): replace with repo function
    return "foo";
  }

  Future<List<String>> getPrivateKeys() async {
    final privateKeyString = await storage.getPrivateKeysString();
    if (privateKeyString != null) {
      return privateKeyString.split(",");
    } else {
      return [];
    }
  }

  Future<void> savePrivateKeys(List<String> privateKeys) async {
    await storage.savePrivateKeys(privateKeys.join(","));
  }
}
