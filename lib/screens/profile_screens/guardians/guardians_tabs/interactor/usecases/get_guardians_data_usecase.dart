import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:seeds/utils/result_extension.dart';

class GetGuardiansDataUseCase {
  // why is this the same as GetGuardiansUseCase
  // TODO(n13): Fix / investigate, could be one used to be on firebase, the other on
  // chain. For this one, everything's on chain.
  Future<Result<UserGuardiansModel>> getGuardiansData() {
    return polkadotRepository.getRecoveryConfig(accountService.currentAccount.address);
  }
}
