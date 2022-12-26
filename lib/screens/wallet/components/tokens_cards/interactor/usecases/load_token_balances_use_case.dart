import 'package:async/async.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/token_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';

class LoadTokenBalancesUseCase {
  Future<List<Result<TokenBalanceModel>>> run() async {
    print("load tokens ..");
    final List<TokenModel> tokens = await polkadotRepository.getTokens();
    final account = accountService.currentAccount.address;
    final List<Future<Result<TokenBalanceModel>>> list = tokens
        .map((item) => polkadotRepository.getBalance(
              account,
              forToken: item,
            ))
        .toList();
    return Future.wait(list);
  }
}
