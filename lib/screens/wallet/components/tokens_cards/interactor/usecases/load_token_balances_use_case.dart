import 'package:async/async.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/api/balance_repository.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/token_model.dart';

class LoadTokenBalancesUseCase {
  Future<List<Result<BalanceModel>>> run(List<TokenModel> tokens) {
    print("load tokens ..");
    final account = accountService.currentAccount.address;
    final List<Future<Result<BalanceModel>>> list = tokens
        .map((item) => BalanceRepository().getTokenBalance(
              account,
              tokenId: item.id,
              symbol: item.symbol,
            ))
        .toList();
    return Future.wait(list);
  }
}
