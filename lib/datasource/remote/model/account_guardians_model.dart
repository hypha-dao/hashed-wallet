import 'package:seeds/datasource/local/models/account.dart';

class UserGuardiansModel {
  static final empty = UserGuardiansModel(guardians: [], timeDelaySec: 60 * 60 * 24);
  final List<Account> guardians;
  final int timeDelaySec;
  bool get isEmpty => guardians.isEmpty;
  bool get areGuardiansActive => !isEmpty;

  int get length => guardians.length;
  List<String> get guardianAddresses => guardians.map((e) => e.address).toList();

  UserGuardiansModel({required this.guardians, required this.timeDelaySec});

  factory UserGuardiansModel.fromTableRows(List<dynamic> rows) {
    if (rows.isNotEmpty && rows[0]['account'].isNotEmpty) {
      final List<String> guardians = List<String>.from(rows[0]['guardians']);
      final int timeDelaySec = rows[0]['time_delay_sec'];
      final List<Account> guardianAccounts = guardians.map((e) => Account(address: e)).toList();
      return UserGuardiansModel(guardians: guardianAccounts, timeDelaySec: timeDelaySec);
    } else {
      return UserGuardiansModel(guardians: [], timeDelaySec: 0);
    }
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
