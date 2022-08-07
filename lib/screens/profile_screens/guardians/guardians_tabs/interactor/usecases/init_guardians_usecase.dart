import 'package:seeds/datasource/remote/model/guardians_config_model.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:seeds/utils/result_extension.dart';

class ActivateGuardiansUseCase {
  Future<Result> createRecovery(GuardiansConfigModel myGuardians) async {
    return polkadotRepository.createRecovery(myGuardians);
  }
}
