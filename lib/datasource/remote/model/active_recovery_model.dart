/// Represents an active recovery
///
class ActiveRecoveryModel {
  final String key;

  /// the account it is trying to recover
  final String lostAccount;

  /// the account started the recovery
  final String rescuer;

  /// the block at which the recovery was created
  final int created;

  /// the deposit amount
  final int deposit;

  /// the list of friends / guardians who have already signed - can be empty
  final List<String> friends;

  ActiveRecoveryModel(
      {required this.key,
      required this.lostAccount,
      required this.rescuer,
      required this.created,
      required this.deposit,
      required this.friends});

  factory ActiveRecoveryModel.fromJson(Map<String, dynamic> json) {
    final key = json["key"];
    final lostAccount = json["lostAccount"];
    final rescuer = json["rescuer"];

    final dynamic data = json["data"];
    final int created = data['created'];
    final int deposit = data['deposit'];
    final friends = List<String>.from(data["friends"]);

    return ActiveRecoveryModel(
      key: key,
      lostAccount: lostAccount,
      rescuer: rescuer,
      created: created,
      deposit: deposit,
      friends: friends,
    );
  }
}

// flutter: getRecoveryConfig res: [{
//   key: 0xa2ce73642c549ae79c14f0a671cf45f9dff9094d7baf1e2d9b2e3a4253b096f86c7090fd2359d471e63883edb4a6a0cdebfac75f34f14f34d3cbffc154ae4c7f28ea266addddf8501493c613e8bdafc0b25475e47c779546c9b6ab58e0bdbdc2245503284a8dfe4c324e6dc285c88a1d,
//   lostAccount: 5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym,
//   rescuer: 5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW,
//   data: {
//     created: 1035220,
//     deposit: 16666666500,
//     friends: []
//   }
// }]

