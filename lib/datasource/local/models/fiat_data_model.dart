import 'package:hashed/datasource/local/models/amount_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';

class FiatDataModel extends AmountDataModel {
  FiatDataModel(double amount, {String? fiatSymbol})
      : super(
          amount: amount,
          symbol: fiatSymbol ?? settingsStorage.selectedFiatCurrency,
          precision: 2,
        );
}
