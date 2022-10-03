import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class GetActiveRecoveryUseCase {
  Future<Result<List<ActiveRecoveryModel>>> run(String lostAccount) {
    return polkadotRepository.recoveryRepository.getActiveRecoveries(lostAccount);
  }
}
