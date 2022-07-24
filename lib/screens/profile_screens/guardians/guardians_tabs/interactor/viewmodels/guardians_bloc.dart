import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/get_guardians_data_usecase.dart';

part 'guardians_event.dart';
part 'guardians_state.dart';

class GuardiansBloc extends Bloc<GuardiansEvent, GuardiansState> {
  final GetGuardiansDataUseCase _getGuardiansDataUseCase = GetGuardiansDataUseCase();
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  GuardiansBloc() : super(GuardiansState.initial()) {
    on<InitGuardians>(_initGuardians);
    on<Initial>(_initial);
    on<OnStopRecoveryForUser>(_onStopRecoveryForUser);
    on<OnRemoveGuardianTapped>(_onRemoveGuardianTapped);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initGuardians(InitGuardians event, Emitter<GuardiansState> emit) async {}

  Future<void> _onStopRecoveryForUser(OnStopRecoveryForUser event, Emitter<GuardiansState> emit) async {
    await _repository.stopRecoveryForUser(settingsStorage.accountName);
  }

  Future<void> _onRemoveGuardianTapped(OnRemoveGuardianTapped event, Emitter<GuardiansState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    /// Remove from server
    // final result = await RemoveGuardianUseCase().removeGuardian(event.guardian);

    /// Delete this mock
    final guards = state.myGuardians;
    guards.remove(event.guardian);
    emit(state.copyWith(
      myGuardians: guards,
      actionButtonState: getActionButtonState(false, guards.length),
      pageState: PageState.success,
    ));
  }

  FutureOr<void> _initial(Initial event, Emitter<GuardiansState> emit) {
    emit(state.copyWith(pageState: PageState.loading));
    final result = _getGuardiansDataUseCase.getGuardiansData();

    emit(state.copyWith(
      myGuardians: result.guardians,
      areGuardiansActive: result.areGuardiansActive,
      actionButtonState: getActionButtonState(result.areGuardiansActive, result.guardians.length),
      pageState: PageState.success,
    ));
  }
}

ActionButtonState getActionButtonState(bool areGuardiansActive, int guardiansCount) {
  return ActionButtonState(
    isLoading: false,
    title: areGuardiansActive ? 'Reset' : 'Activate',
    isEnabled: areGuardiansActive || (!areGuardiansActive && guardiansCount > 3),
  );
}
