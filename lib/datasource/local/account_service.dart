import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';

class Account extends Equatable {
  String address;
  String name;
  Account(this.address, this.name);

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "name": name,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      json["address"],
      json["name"],
    );
  }

  static List<Account> listFromJson(String jsonString) {
    final List items = json.decode(jsonString) as List;
    return items.map((e) => Account.fromJson(e)).toList();
  }

  static String jsonFromList(List<Account> accounts) {
    final res = json.encode(accounts);
    print("json str: $res");
    return res;
  }

  @override
  List<Object?> get props => [name, address];
}

class AccountService {
  Future<List<Account>> loadAccounts() async {
    final accountString = settingsStorage.accounts ?? "[]";
    return Account.listFromJson(accountString);
  }

  void saveAccounts(List<Account> accounts) {
    settingsStorage.saveAccounts(Account.jsonFromList(accounts));
  }

  void addKey(String key) {}

  Future<Account?> createAccount(String name, String privateKey) async {
    if (privateKey.contains(",")) {
      throw ArgumentError("illegal character in private key: ',': $privateKey");
    }
    Account? result = null;
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
    final privateKeyString = await settingsStorage.getPrivateKeysString();
    if (privateKeyString != null) {
      return privateKeyString.split(",");
    } else {
      return [];
    }
  }

  Future<void> savePrivateKeys(List<String> privateKeys) async {
    await settingsStorage.savePrivateKeys(privateKeys.join(","));
  }
}
