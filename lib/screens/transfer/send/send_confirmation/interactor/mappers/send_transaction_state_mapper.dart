import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/transaction_results.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:hashed/utils/rate_states_extensions.dart';

class SendTransactionStateMapper extends StateMapper {
  SendConfirmationState mapResultToState(
    SendConfirmationState currentState,
    Result result,
    RatesState rateState,
  ) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowFailedTransactionReason(
          title: 'Error Sending Transaction',
          details: '${result.asError!.error}',
        ),
        transactionResult: TransactionResult(
          status: TransactionResultStatus.failure,
          message: '${result.asError!.error}',
        ),
      );
    } else {
      final resultResponse = result.asValue!.value as String;

      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: transactionResultPageCommand(currentState.transaction, resultResponse, rateState),
        transactionResult: TransactionResult(
          status: TransactionResultStatus.success,
          message: resultResponse,
        ),
      );
    }
  }

  // TODO(n13): move this from here and put it in its own class - something to distinguish between
  // known and generic (unknown) types of transactions results. Now we have generic and transfer, could
  // add invite, guardians, etc - all transactions we know about.
  static TransactionPageCommand transactionResultPageCommand(
    SendTransaction transaction,
    String resultResponse,
    RatesState rateState,
  ) {
    FiatDataModel? fiatAmount;

    fiatAmount = rateState.tokenToFiat(transaction.quantity, settingsStorage.selectedFiatCurrency);

    return ShowTransferSuccess(
      tokenDataModel: transaction,
      transactionHash: resultResponse,
      fiatAmount: fiatAmount,
    );
  }
}
