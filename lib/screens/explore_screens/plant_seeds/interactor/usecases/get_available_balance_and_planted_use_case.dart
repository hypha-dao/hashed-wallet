import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/api/planted_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class GetAvailableBalanceAndPlantedDataUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();
  final PlantedRepository _plantedRepository = PlantedRepository();

  Future<List<Result>> run() {
    final account = settingsStorage.accountName;
    final futures = [
      _balanceRepository.getTokenBalance(account, tokenContract: seedsToken.contract, symbol: seedsToken.symbol),
      _plantedRepository.getPlanted(account),
    ];
    return Future.wait(futures);
  }
}
