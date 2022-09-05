import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class GetGuardiansDataUseCase {
  Future<Result<GuardiansConfigModel>> getGuardiansData() {
    return polkadotRepository.recoveryRepository.getRecoveryConfig(accountService.currentAccount.address);
  }
}
