import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';

class InitialValidationStateMapper extends StateMapper {
  // TODO(n13): Remove this
  SendConfirmationState mapResultToState(SendConfirmationState currentState, Result<TokenBalanceModel> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      // final TokenBalanceModel balance = result.asValue!.value;
      // final amountRequested = currentState.signingRequest.quantity.amount;
      // final hasEnoughBalance = (balance.balance.quantity - amountRequested) >= 0;
      // if (true) {
      return currentState.copyWith(pageState: PageState.success);
      // } else {
      // return currentState.copyWith(
      //   pageState: PageState.success,
      //   pageCommand:
      //       ShowInvalidTransactionReason('You do not have enough ${currentState.signingRequest.quantity.symbol}'),
      //   invalidTransaction: InvalidTransaction.insufficientBalance,
      // );
      // }
    }
  }
}
