import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/app/account_under_recovery/interactor/viewmodels/account_under_recovery_event.dart';
import 'package:hashed/screens/app/account_under_recovery/interactor/viewmodels/account_under_recovery_state.dart';
import 'package:hashed/screens/app/interactor/mappers/stop_guardian_recovery_state_mapper.dart';
import 'package:hashed/screens/app/interactor/usecases/stop_guardian_recovery_use_case.dart';

class AccountUnderRecoveryBloc extends Bloc<AccountUnderRecoveryEvent, AccountUnderRecoveryState> {
  AccountUnderRecoveryBloc(recoveries) : super(AccountUnderRecoveryState.initial(recoveries)) {
    on<OnStopGuardianActiveRecoveryTapped>(_onStopGuardianActiveRecovery);
  }

  Future<void> _onStopGuardianActiveRecovery(
      OnStopGuardianActiveRecoveryTapped event, Emitter<AccountUnderRecoveryState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    final result = await StopGuardianRecoveryUseCase().run(state.recoveries);

    emit(StopGuardianRecoveryStateMapper().mapResultToState(state, result));
  }
}
