import 'package:async/async.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/member_bloc.dart';

class MemberStateMapper {
  MemberState mapResultToState(MemberState currentState, Result result) {
    return result.isError
        ? currentState.copyWith(pageState: PageState.failure)
        : currentState.copyWith(
            member: result.asValue?.value,
            pageState: PageState.success,
          );
  }
}
