import 'package:hashed/datasource/remote/model/active_recovery_model.dart';

class GuardianRecoveryRequestData {
  final String lostAccount;
  final String rescuer;

  GuardianRecoveryRequestData({
    required this.lostAccount,
    required this.rescuer,
  });

  factory GuardianRecoveryRequestData.fromRecovery(ActiveRecoveryModel model) {
    return GuardianRecoveryRequestData(lostAccount: model.lostAccount, rescuer: model.rescuer);
  }
}
