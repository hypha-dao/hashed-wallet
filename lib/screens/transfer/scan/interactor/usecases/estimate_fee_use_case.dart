import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class EstimateFeeUseCase {
  Future<Result<TokenBalanceModel>> run(SubstrateTransactionModel transaction) async {
    final res = await polkadotRepository.balancesRepository.estimateFees(transaction);
    final token = polkadotRepository.currentToken;
    if (res.isError) {
      return Result.error("Error ${res.asError!.error}");
    } else if (token == null) {
      return Result.error("Error - No Token Set");
    } else {
      final fee = res.asValue!.value;
      return Result.value(fee.toTokenBalanceModel(token));
    }
  }
}
