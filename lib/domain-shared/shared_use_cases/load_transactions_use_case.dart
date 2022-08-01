import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/remote/api/transactions_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class LoadTransactionsUseCase extends NoInputUseCase<List<TransactionModel>> {
  @override
  Future<Result<List<TransactionModel>>> run() {
    return TransactionsListRepository().getTransactions(accountService.currentAccount.address);
  }
}
