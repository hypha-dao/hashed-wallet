import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class GetActiveRecoveryForLostAccountUseCase {
  Future<Result<ActiveRecoveryModel>> run({required String rescuer, required String lostAccount}) {
    return polkadotRepository.recoveryRepository
        .getActiveRecoveriesForLostaccount(rescuer: rescuer, lostAccount: lostAccount);
  }
}
