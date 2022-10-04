import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountSuccessDataUseCase {
  Future<Result<BalanceModel>> run(String accountName) async {
    // TODO(Nik): This is mocked data. We need to make calls to the repo to get the data we need and Map it to a
    // TODO(Nik): ResultData object. The bloc will know how to handle this object. If fails, return Result.error()

    // What's the accountName parameter = the lost account? The rescuer account?
    final res = polkadotRepository.getBalance(accountName);

    return res;
  }
}
