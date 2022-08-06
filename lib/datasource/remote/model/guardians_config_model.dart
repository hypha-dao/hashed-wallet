import 'package:seeds/datasource/local/models/account.dart';

class GuardiansConfigModel {
  static final empty = GuardiansConfigModel(guardians: [], delayPeriod: 0, threshold: 0);
  final List<Account> guardians;
  final int delayPeriod;
  final int threshold;
  bool get isEmpty => guardians.isEmpty;
  bool get areGuardiansActive => !isEmpty;

  int get length => guardians.length;
  List<String> get guardianAddresses => guardians.map((e) => e.address).toList();

  GuardiansConfigModel({required this.guardians, required this.delayPeriod, required this.threshold});

  // factory UserGuardiansModel.fromTableRows(List<dynamic> rows) {
  //   if (rows.isNotEmpty && rows[0]['account'].isNotEmpty) {
  //     final List<String> guardians = List<String>.from(rows[0]['guardians']);
  //     final int timeDelaySec = rows[0]['time_delay_sec'];
  //     final List<Account> guardianAccounts = guardians.map((e) => Account(address: e)).toList();
  //     return UserGuardiansModel(guardians: guardianAccounts, timeDelaySec: timeDelaySec, threshold: 2);
  //   } else {
  //     return UserGuardiansModel(guardians: [], timeDelaySec: 0, threshold: 0);
  //   }
  // }

  factory GuardiansConfigModel.fromJson(Map<String, dynamic> json) {
    final List<String> guardians = List<String>.from(json['friends']);
    final int timeDelaySec = json['delayPeriod'];
    final List<Account> guardianAccounts = guardians.map((e) => Account(address: e)).toList();
    final int threshold = json['threshold'];
    return GuardiansConfigModel(
      guardians: guardianAccounts,
      delayPeriod: timeDelaySec,
      threshold: threshold,
    );
    // flutter: getRecoveryConfig res:
    //{delayPeriod: 0,
    //deposit: 21666666450,
    //friends: [5C8126sqGbCa3m7Bsg8BFQ4arwcG81Vbbwi34EznBovrv7Zf, 5Ca9Sdw7dxUK62FGkKXSZPr8cjNLobuGAgXu6RCM14aKtz6T, 5FyG1HpMSce9As8Uju4rEQnL24LZ8QNFDaKiu5nQtX6CY6BH],
    //threshold: 2,
    //address: 5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA}
  }

  void add(Account account) {
    if (!guardians.contains(account)) {
      guardians.add(account);
    }
  }

  void remove(Account guardian) {
    guardians.remove(guardian);
  }
}
