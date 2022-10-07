import 'package:async/async.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';

class ApproveGuardianRecoveryUseCase {
  Future<Result<dynamic>> approveGuardianRecovery(
      {required String account, required String lostAccount, required String rescuer}) async {
    return polkadotRepository.recoveryRepository.vouch(
      account: account,
      lostAccount: lostAccount,
      recovererAccount: rescuer,
    );
  }
}
