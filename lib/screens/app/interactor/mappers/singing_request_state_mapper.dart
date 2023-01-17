import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/i18n/app/app.i18.dart';
import 'package:hashed/screens/app/interactor/viewmodels/app_bloc.dart';
import 'package:hashed/screens/app/interactor/viewmodels/app_page_commands.dart';

// TODO(n13): Old, possibly useless code.
class SingingRequestStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        pageCommand: ShowErrorMessage("Oops, something went wrong".i18n),
      );
    } else {
      final SubstrateSigningRequestModel? request = result.asValue!.value;

      if (request != null) {
        return currentState.copyWith(
            pageCommand: ProcessSigningRequest(request),
            showGuardianApproveOrDenyScreen: currentState.showGuardianApproveOrDenyScreen);
      } else {
        // No initial uri
        return currentState;
      }
    }
  }
}
