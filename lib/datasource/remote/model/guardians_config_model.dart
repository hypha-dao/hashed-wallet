import 'package:seeds/datasource/local/models/account.dart';

class GuardiansConfigModel {
  static const int defaultDelayPeriod = 10 * 60 * 24;
  final Set<Account> guardians;
  final int delayPeriod;
  int threshold;

  bool get isEmpty => guardians.isEmpty;

  int get length => guardians.length;

  List<String> get guardianAddresses => guardians.map((e) => e.address).toList();

  GuardiansConfigModel({required this.guardians, required this.delayPeriod, required this.threshold});

  factory GuardiansConfigModel.empty() {
    return GuardiansConfigModel(guardians: {}, delayPeriod: defaultDelayPeriod, threshold: 0);
  }

  factory GuardiansConfigModel.fromJson(Map<String, dynamic> json) {
    final List<String> guardians = List<String>.from(json['friends']);
    final int delayPeriod = json['delayPeriod'];
    final Set<Account> guardianAccounts = guardians.map((e) => Account(address: e)).toSet();
    final int threshold = json['threshold'];
    return GuardiansConfigModel(
      guardians: guardianAccounts,
      delayPeriod: delayPeriod,
      threshold: threshold,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'friends': guardians.map((e) => e.address).toList(),
        'delayPeriod': delayPeriod,
        'threshold': threshold,
      };

  void add(Account account) {
    guardians.add(account);
    autoConfigureThreshold();
  }

  void remove(Account guardian) {
    guardians.remove(guardian);
    autoConfigureThreshold();
  }

  void autoConfigureThreshold() {
    final count = guardians.length;
    if (count == 0) {
      threshold = 0;
    } else if (count <= 2) {
      threshold = 1; // 1/1, 1/2
    } else if (count == 3) {
      threshold = 2; // 2/3
    } else if (count <= 5) {
      threshold = 3; // 3/4, 3/5
    } else if (count <= 7) {
      threshold = 4; // 4/6, 4/7
    } else {
      threshold = count * 2 ~/ 3; // 5/8, 6/9, ...
    }
  }
}
