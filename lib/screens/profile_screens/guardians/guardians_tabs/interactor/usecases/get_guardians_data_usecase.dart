import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class GetGuardiansConfigUseCase {
  Future<Result<GuardiansConfigModel>> getGuardiansData(String account) {
    return polkadotRepository.recoveryRepository.getRecoveryConfig(account);
  }
}
