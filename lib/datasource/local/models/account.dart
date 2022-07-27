import 'dart:convert';

import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String address;
  final String name;
  const Account(this.address, this.name);

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

  @override
  String toString() {
    return "${toJson()}";
  }
}
