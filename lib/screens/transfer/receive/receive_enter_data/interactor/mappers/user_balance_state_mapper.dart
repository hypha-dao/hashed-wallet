
// [POLKA] see if we need this - I think not
// class UserBalanceStateMapper extends StateMapper {
//   ReceiveEnterDataState mapResultToState(ReceiveEnterDataState currentState, Result<BalanceModel> result) {
//     if (result.isError) {
//       return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
//     } else {
//       final balance = result.asValue!.value;
//       final availableBalance = TokenDataModel.fromSelected(balance.quantity);
//       final String selectedFiat = settingsStorage.selectedFiatCurrency;
//       final RatesState rateState = currentState.ratesState;
//       return currentState.copyWith(
//         pageState: PageState.success,
//         availableBalanceFiat: rateState.tokenToFiat(availableBalance, selectedFiat),
//         availableBalanceToken: availableBalance,
//       );
//     }
//   }
// }
