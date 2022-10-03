import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/i18n/app/app.i18.dart';
import 'package:hashed/screens/app/interactor/viewmodels/app_bloc.dart';

class StopGuardianRecoveryStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, List<Result> result) {
    final errors = result.where((element) => element.isError);

    if (errors.isNotEmpty) {
      errors.map((e) => print("error: $e\n"));
      return currentState.copyWith(
          pageState: PageState.failure,
          pageCommand: ShowErrorMessage("Oops, something went wrong.".i18n),
          showGuardianRecoveryAlert: false,
          activeRecoveries: []);
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowMessage("Success, guardians recovery stopped".i18n),
        showGuardianRecoveryAlert: false,
        activeRecoveries: [],
      );
    }
  }
}
