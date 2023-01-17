import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_bloc.dart';
import 'package:hashed/utils/rate_states_extensions.dart';

class UserBalanceStateMapper extends StateMapper {
  ReceiveEnterDataState mapResultToState(ReceiveEnterDataState currentState, Result<TokenBalanceModel> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      final balance = result.asValue!.value.balance;
      final availableBalance = TokenDataModel.fromSelected(balance.quantity);
      final String selectedFiat = settingsStorage.selectedFiatCurrency;
      final RatesState rateState = currentState.ratesState;
      return currentState.copyWith(
        pageState: PageState.success,
        availableBalanceFiat: rateState.tokenToFiat(availableBalance, selectedFiat),
        availableBalanceToken: availableBalance,
      );
    }
  }
}
