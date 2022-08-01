import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetAvailableBalanceUseCase extends InputUseCase<BalanceModel, TokenModel> {
  final BalanceRepository _balanceRepository = BalanceRepository();

  @override
  Future<Result<BalanceModel>> run(TokenModel input) {
    print("get avail balance");
    return _balanceRepository.getTokenBalance(
      accountService.currentAccount.address,
      tokenId: input.id,
      symbol: input.symbol,
    );
  }
}
