import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';
import 'package:hashed/utils/rate_states_extensions.dart';

class SendEnterDataStateMapper extends StateMapper {
  SendEnterDataState mapResultToState(
      SendEnterDataState currentState, Result<TokenBalanceModel> result, RatesState rateState, String quantity) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      final TokenBalanceModel balance = result.asValue!.value;
      final availableBalance = TokenDataModel(balance.balance.quantity, token: balance.token);

      return currentState.copyWith(
        pageState: PageState.success,
        availableBalance: availableBalance,
        availableBalanceFiat: rateState.tokenToFiat(availableBalance, settingsStorage.selectedFiatCurrency),
      );
    }
  }
}
