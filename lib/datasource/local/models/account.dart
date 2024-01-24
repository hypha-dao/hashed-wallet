import 'dart:convert';

import 'package:equatable/equatable.dart';

class Account extends Equatable {
  static const empty = Account(address: "", name: "");
  final String address;
  final String? name;
  const Account({this.name, required this.address});

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "name": name,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json["name"] as String?,
      address: json["address"] as String,
    );
  }

  static List<Account> listFromJson(String jsonString) {
    final items = json.decode(jsonString) as List<Map<String, dynamic>>;
    return items.map((e) => Account.fromJson(e)).toList();
  }

  static String jsonFromList(List<Account> accounts) {
    final res = json.encode(accounts);
    return res;
  }

  @override
  List<Object?> get props => [name, address];

  @override
  String toString() {
    return "${toJson()}";
  }

  bool get isEmpty => this == Account.empty;
}
