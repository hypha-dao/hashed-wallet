import 'package:hashed/datasource/remote/model/profile_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class UserAccountStateMapper extends StateMapper {
  WalletState mapResultToState(WalletState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      final ProfileModel? profile = result.asValue!.value;

      return currentState.copyWith(pageState: PageState.success, profile: profile);
    }
  }
}
