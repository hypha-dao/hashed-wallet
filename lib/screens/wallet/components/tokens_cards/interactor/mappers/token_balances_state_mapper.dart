import 'package:hashed/datasource/local/color_pallette_repository.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/token_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balance_view_model.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';

class TokenBalancesStateMapper {
  Future<TokenBalancesState> mapResultToState(
      TokenBalancesState currentState, List<Result<TokenBalanceModel>> results) async {
    final List<TokenBalanceViewModel> available = [];

    for (final result in results) {
      if (result.isValue) {
        final TokenBalanceModel tokenBalance = result.asValue!.value;
        final balance = tokenBalance.balance;
        final token = tokenBalance.token;
        available.add(TokenBalanceViewModel(token, TokenDataModel(balance.quantity, token: token)));
      } else {
        print("error loading");
      }
    }

    // load colors
    final repo = ColorPaletteRepository();
    for (final TokenBalanceViewModel viewModel in available) {
      if (viewModel.token != hashedToken) {
        viewModel.dominantColor = await repo.getImagePaletteCached(viewModel.token.backgroundImage);
      }
    }

    return currentState.copyWith(
        pageState: PageState.success, availableTokens: available.isNotEmpty ? available : currentState.availableTokens);
  }
}
