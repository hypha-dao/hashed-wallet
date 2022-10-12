import 'package:equatable/equatable.dart';

/// Represents an active recovery
///
class ActiveRecoveryModel extends Equatable {
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

  bool get isEmpty => this == ActiveRecoveryModel.empty;

  bool get isNotEmpty => !isEmpty;

  const ActiveRecoveryModel({
    required this.lostAccount,
    required this.rescuer,
    required this.created,
    required this.deposit,
    required this.friends,
  });

  factory ActiveRecoveryModel.fromJson(Map<String, dynamic> json) {
    final lostAccount = json["lostAccount"];
    final rescuer = json["rescuer"];

    final dynamic data = json["data"];
    final int created = data['created'];
    final int deposit = data['deposit'];
    final friends = List<String>.from(data["friends"]);

    return ActiveRecoveryModel(
      lostAccount: lostAccount,
      rescuer: rescuer,
      created: created,
      deposit: deposit,
      friends: friends,
    );
  }

  /// Use this factory model for results for a specific rescuer / lostAccount
  /// combination.
  factory ActiveRecoveryModel.fromJsonSingle({
    required String rescuer,
    required String lostAccount,
    required Map<String, dynamic> json,
  }) {
    final int created = json['created'];
    final int deposit = json['deposit'];
    final friends = List<String>.from(json["friends"]);

    return ActiveRecoveryModel(
      lostAccount: lostAccount,
      rescuer: rescuer,
      created: created,
      deposit: deposit,
      friends: friends,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lostAccount": lostAccount,
      "rescuer": rescuer,
      "data": {
        "created": created,
        "deposit": deposit,
        "friends": friends,
      }
    };
  }

  static final mock = const ActiveRecoveryModel(
    lostAccount: "5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym",
    rescuer: "5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW",
    created: 1035220,
    deposit: 16666666500,
    friends: ["5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW"],
  );

  static final empty = const ActiveRecoveryModel(
    lostAccount: "",
    rescuer: "",
    created: 0,
    deposit: 0,
    friends: [],
  );

  @override
  List<Object?> get props => [lostAccount, rescuer, created, deposit, friends];
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
