import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_transaction_response.dart';

import 'package:seeds/v2/utils/rate_states_extensions.dart';

class SendTransactionStateMapper extends StateMapper {
  SendConfirmationState mapResultToState(SendConfirmationState currentState, Result result, RatesState rateState) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final resultResponse = result.asValue!.value as SendTransactionResponse;

      return currentState.copyWith(
          pageState: PageState.success, pageCommand: transactionResultPageCommand(resultResponse, rateState));
    }
  }

  // TODO(n13): move this from here and put it in its own class - something to distinguish between
  // known and generic (unknown) types of transactions results. Now we have generic and transfer, could
  // add invite, guardians, etc - all transactions we know about.
  static TransactionPageCommand transactionResultPageCommand(
      SendTransactionResponse resultResponse, RatesState rateState) {
    if (resultResponse.isTransfer) {
      final transfer = resultResponse.transferTransactionModel!;
      final fiatQuantity = rateState.fromSeedsToFiat(transfer.doubleQuantity, settingsStorage.selectedFiatCurrency);
      return ShowTransferSuccess(
        transactionModel: transfer,
        from: resultResponse.parseFromUser,
        to: resultResponse.parseToUser,
        quantity: transfer.doubleQuantity,
        fiatQuantity: fiatQuantity,
      );
    } else {
      return ShowTransactionSuccess(
        transactionModel: resultResponse.transactionModel,
      );
    }
  }
}