import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/app/account_under_recovery/interactor/viewmodels/account_under_recovery_event.dart';
import 'package:hashed/screens/app/account_under_recovery/interactor/viewmodels/account_under_recovery_state.dart';

class StopGuardianRecoveryStateMapper extends StateMapper {
  AccountUnderRecoveryState mapResultToState(AccountUnderRecoveryState currentState, List<Result> result) {
    final errors = result.where((element) => element.isError);
    if (errors.isNotEmpty) {
      errors.map((e) => print("error: ${e.asError!.error}"));
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      return currentState.copyWith(pageState: PageState.success, pageCommand: OnShowSuccessDialogPageCommand());
    }
  }
}
