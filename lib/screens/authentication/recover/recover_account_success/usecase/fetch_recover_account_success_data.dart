import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountSuccessDataUseCase {
  Future<Result<BalanceModel>> run(String accountName) async {
    return polkadotRepository.getBalance(accountName);
  }
}
