import 'package:seeds/datasource/local/models/account.dart';

class GuardiansConfigModel {
  static const int defaultDelayPeriod = 10 * 60 * 24;
  static final empty = GuardiansConfigModel(guardians: [], delayPeriod: defaultDelayPeriod, threshold: 0);
  final List<Account> guardians;
  final int delayPeriod;
  int threshold;
  bool get isEmpty => guardians.isEmpty;
  bool get areGuardiansActive => !isEmpty;

  int get length => guardians.length;
  List<String> get guardianAddresses => guardians.map((e) => e.address).toList();

  GuardiansConfigModel({required this.guardians, required this.delayPeriod, required this.threshold});

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
