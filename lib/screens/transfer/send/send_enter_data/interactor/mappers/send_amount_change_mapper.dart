import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';
import 'package:hashed/utils/rate_states_extensions.dart';

class SendAmountChangeMapper extends StateMapper {
  SendEnterDataState mapResultToState(SendEnterDataState currentState, RatesState rateState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;

    final tokenAmount = TokenDataModel(parsedQuantity, token: settingsStorage.selectedToken);
    final selectedFiat = settingsStorage.selectedFiatCurrency;
    final fiatAmount = rateState.tokenToFiat(tokenAmount, selectedFiat);

    final double currentAvailable = currentState.availableBalance?.amount ?? 0;

    final bool enoughBalance = parsedQuantity <= currentAvailable ||
        currentState.availableBalance?.asFormattedString() == tokenAmount.asFormattedString();

    return currentState.copyWith(
      fiatAmount: fiatAmount,
      isNextButtonEnabled: parsedQuantity > 0 && enoughBalance,
      tokenAmount: tokenAmount,
      showAlert: !enoughBalance,
    );
  }
}
