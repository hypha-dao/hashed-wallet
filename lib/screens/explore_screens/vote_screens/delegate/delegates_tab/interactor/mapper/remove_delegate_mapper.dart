import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegates_bloc.dart';

class RemoveDelegateResultMapper extends StateMapper {
  DelegatesState mapResultToState(DelegatesState currentState, Result result) {
    if (result.isError) {
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Fail to remove delegate'),
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        activeDelegate: false,
        shouldRefreshCurrentDelegates: true,
      );
    }
  }
}
