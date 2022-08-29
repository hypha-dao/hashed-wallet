import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';

class SendTransactionMapper extends StateMapper {
  SendEnterDataState mapResultToState(SendEnterDataState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final resultResponse = result.asValue!.value as String;

      final transaction = SendTransaction(accountService.currentAccount, currentState.sendTo, currentState.tokenAmount);

      final pageCommand = SendTransactionStateMapper.transactionResultPageCommand(
        transaction,
        resultResponse,
        currentState.ratesState,
      );
      eventBus.fire(OnNewTransactionEventBus(transaction));

      return currentState.copyWith(pageState: PageState.success, pageCommand: pageCommand);
    }
  }
}
