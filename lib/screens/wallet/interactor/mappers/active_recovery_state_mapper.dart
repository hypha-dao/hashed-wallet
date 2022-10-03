import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_bloc.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_page_command.dart';

class ActiveRecoveryStateMapper extends StateMapper {
  WalletState mapResultToState(WalletState currentState, Result result) {
    if (result.isError) {
      // ignore
      return currentState;
    } else {
      final List<ActiveRecoveryModel> recoveries = result.asValue!.value;

      if (recoveries.isEmpty) {
        return currentState.copyWith(pageState: PageState.success);
      } else {
        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: OnRecoveryActivePageCommand(recoveries),
          activeRecoveries: recoveries,
        );
      }
    }
  }
}
