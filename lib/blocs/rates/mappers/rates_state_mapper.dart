import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/remote/model/fiat_rate_model.dart';
import 'package:hashed/datasource/remote/model/rate_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';

class RatesStateMapper extends StateMapper {
  static const husdTokenId = 'husd.hypha#HUSD';
  static const telosTokenId = 'eosio.token#TLOS';
  static const seedsTokenId = 'token.seeds#SEEDS';
  RatesState mapResultToState(RatesState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Cannot fetch balance...');
    } else {
      /// note: we re-use existing conversion rates if we can't load new ones
      final RateModel? seedsRateModel = results[0].asValue?.value ?? currentState.rates?[seedsTokenId];
      final RateModel? telosRateModel = results[1].asValue?.value ?? currentState.rates?[telosTokenId];
      final rates = {
        husdTokenId: const RateModel(husdTokenId, 1),
      };
      if (seedsRateModel != null) {
        rates[seedsTokenId] = seedsRateModel;
      }
      if (telosRateModel != null) {
        rates[telosTokenId] = telosRateModel;
      }
      final FiatRateModel? fiatRate = results[2].asValue?.value;
      return currentState.copyWith(rates: rates, fiatRate: fiatRate);
    }
  }
}
