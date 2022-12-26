import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class GetAvailableBalanceUseCase {
  Future<Result<TokenBalanceModel>> run() {
    return polkadotRepository.getBalance(
      accountService.currentAccount.address,
    );
  }
}
