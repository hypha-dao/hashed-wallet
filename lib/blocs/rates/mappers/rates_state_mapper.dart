import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/remote/model/fiat_rate_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';

class RatesStateMapper extends StateMapper {
  static const husdTokenId = 'husd.hypha#HUSD';
  static const telosTokenId = 'eosio.token#TLOS';
  static const seedsTokenId = 'token.seeds#SEEDS';
  RatesState mapResultToState(RatesState currentState, List<Result<FiatRateModel>> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Cannot fetch balance...');
    } else {
      final FiatRateModel? fiatRate = results[0].asValue?.value;
      return currentState.copyWith(rates: {}, fiatRate: fiatRate);
    }
  }
}
