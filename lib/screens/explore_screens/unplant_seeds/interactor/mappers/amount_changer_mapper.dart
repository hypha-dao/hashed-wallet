import 'package:flutter/material.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_bloc.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_page_commands.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class AmountChangerMapper extends StateMapper {
  UnplantSeedsState mapResultToState(UnplantSeedsState currentState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;
    final selectedFiat = settingsStorage.selectedFiatCurrency;

    TokenDataModel? tokenAmount;
    FiatDataModel? fiatAmount;
    final double currentAvailable = currentState.plantedBalance?.amount ?? 0;
    tokenAmount = currentState.unplantedInputAmount.copyWith(parsedQuantity);
    fiatAmount = currentState.ratesState.tokenToFiat(tokenAmount, selectedFiat);

    final TextEditingValue newAmountController =
        TextEditingValue(text: quantity, selection: TextSelection.fromPosition(TextPosition(offset: quantity.length)));

    return currentState.copyWith(
      pageCommand: UpdateTextController(newAmountController),
      onFocus: false,
      unplantedInputAmount: tokenAmount,
      unplantedInputAmountFiat: fiatAmount,
      isUnplantSeedsButtonEnabled:
          parsedQuantity > 0 && parsedQuantity <= currentAvailable && parsedQuantity <= (currentAvailable - minPlanted),
      showOverBalanceAlert: parsedQuantity > currentAvailable,
      showMinPlantedBalanceAlert: parsedQuantity > (currentAvailable - minPlanted),
    );
  }
}
