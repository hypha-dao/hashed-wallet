import 'package:async/async.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_bloc.dart';

class TransactionsListStateMapper {
  TransactionsListState mapResultToState(TransactionsListState currentState, Result transactionsResult) {
    return transactionsResult.isError
        ? currentState.copyWith(pageState: PageState.failure)
        : currentState.copyWith(
            transactions: transactionsResult.asValue?.value,
            pageState: PageState.success,
          );
  }
}
