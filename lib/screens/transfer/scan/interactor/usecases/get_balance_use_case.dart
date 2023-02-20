import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class GetBalanceUseCase {
  Future<Result<TokenBalanceModel>> run() async {
    final address = accountService.currentAccount.address;
    return polkadotRepository.getBalance(address);
  }
}
