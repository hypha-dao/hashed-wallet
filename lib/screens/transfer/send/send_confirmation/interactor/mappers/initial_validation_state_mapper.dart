import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';

class InitialValidationStateMapper extends StateMapper {
  SendConfirmationState mapResultToState(SendConfirmationState currentState, Result<BalanceModel> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      final BalanceModel balance = result.asValue!.value;
      final eosAction = currentState.transaction.actions.first;
      final amountRequested = (eosAction.data?['quantity'] as String).split(' ').first;
      final hasEnoughBalance = (balance.quantity - double.parse(amountRequested)) >= 0;
      if (hasEnoughBalance) {
        return currentState.copyWith(pageState: PageState.success);
      } else {
        final tokenRequested = (eosAction.data?['quantity'] as String).split(' ').last;
        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowInvalidTransactionReason('You do not have enough $tokenRequested'),
          invalidTransaction: InvalidTransaction.insufficientBalance,
        );
      }
    }
  }
}
