import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/api/transactions_repository.dart';
import 'package:hashed/datasource/remote/model/transaction_model.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class LoadTransactionsUseCase extends NoInputUseCase<List<TransactionModel>> {
  @override
  Future<Result<List<TransactionModel>>> run() {
    return TransactionsListRepository().getTransactions(accountService.currentAccount.address);
  }
}
