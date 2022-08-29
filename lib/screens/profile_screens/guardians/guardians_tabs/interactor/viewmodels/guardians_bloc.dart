import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/get_guardians_data_usecase.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/init_guardians_usecase.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';
import 'package:hashed/utils/result_extension.dart';

part 'guardians_event.dart';
part 'guardians_state.dart';

class GuardiansBloc extends Bloc<GuardiansEvent, GuardiansState> {
  final GetGuardiansDataUseCase _getGuardiansDataUseCase = GetGuardiansDataUseCase();
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  GuardiansBloc() : super(GuardiansState.initial()) {
    on<Initial>(_initial);
    on<OnMyGuardianActionButtonTapped>(_onMyGuardianActionButtonTapped);
    on<OnStopRecoveryForUser>(_onStopRecoveryForUser);
    on<OnRemoveGuardianTapped>(_onRemoveGuardianTapped);
    on<OnGuardianAdded>(_onGuardianAdded);
    on<OnResetConfirmed>(_onResetConfirmed);
    on<OnActivateConfirmed>(_onActivateConfirmed);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onStopRecoveryForUser(OnStopRecoveryForUser event, Emitter<GuardiansState> emit) async {
    await _repository.stopRecoveryForUser(accountService.currentAccount.address);
  }

  Future<void> _onRemoveGuardianTapped(OnRemoveGuardianTapped event, Emitter<GuardiansState> emit) async {
    final guards = state.myGuardians;
    guards.remove(event.guardian);
    emit(state.copyWith(
      areGuardiansActive: false,
      myGuardians: guards,
      actionButtonState: getActionButtonState(areGuardiansActive: false, guardiansCount: guards.length),
      pageState: PageState.success,
    ));
  }

  FutureOr<void> _initial(Initial event, Emitter<GuardiansState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<GuardiansConfigModel> result = await _getGuardiansDataUseCase.getGuardiansData();

    if (result.isValue) {
      final guardiansModel = result.asValue!.value;
      emit(state.copyWith(
        myGuardians: guardiansModel,
        areGuardiansActive: !guardiansModel.isEmpty,
        actionButtonState: getActionButtonState(
          areGuardiansActive: !guardiansModel.isEmpty,
          guardiansCount: guardiansModel.length,
        ),
        pageState: PageState.success,
      ));
    } else {
      /// Show UI error
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onGuardianAdded(OnGuardianAdded event, Emitter<GuardiansState> emit) {
    final guards = state.myGuardians;
    guards.add(event.account);
    emit(state.copyWith(
        myGuardians: guards,
        actionButtonState: getActionButtonState(
          areGuardiansActive: false,
          guardiansCount: guards.length,
        )));
  }

  FutureOr<void> _onMyGuardianActionButtonTapped(OnMyGuardianActionButtonTapped event, Emitter<GuardiansState> emit) {
    if (state.areGuardiansActive) {
      /// reset
      emit(state.copyWith(pageCommand: ShowResetGuardians()));
    } else {
      /// activate
      emit(state.copyWith(pageCommand: ShowActivateGuardians()));
    }
  }

  FutureOr<void> _onResetConfirmed(OnResetConfirmed event, Emitter<GuardiansState> emit) async {
    emit(state.copyWith(actionButtonState: state.actionButtonState.setLoading(true)));

    final result = await polkadotRepository.removeRecovery();
    if (result.isValue) {
      emit(GuardiansState.initial());
    } else {
      emit(state.copyWith(
        actionButtonState: state.actionButtonState.setLoading(false),
        pageCommand: ShowErrorMessage(result.asError?.error.toString() ?? 'Oops, something went wrong'),
      ));
    }
  }

  FutureOr<void> _onActivateConfirmed(OnActivateConfirmed event, Emitter<GuardiansState> emit) async {
    emit(state.copyWith(actionButtonState: state.actionButtonState.setLoading(true)));

    final Result result = await ActivateGuardiansUseCase().createRecovery(event.guards);

    if (result.isValue) {
      emit(state.copyWith(
        areGuardiansActive: true,
        actionButtonState: getActionButtonState(
          areGuardiansActive: true,
          guardiansCount: event.guards.length,
        ),
      ));
    } else {
      emit(state.copyWith(
        actionButtonState: state.actionButtonState.setLoading(false),
        pageCommand: ShowErrorMessage(result.asError?.error.toString() ?? 'Oops, something went wrong'),
      ));
    }
  }
}

ActionButtonState getActionButtonState({required bool areGuardiansActive, required int guardiansCount}) {
  if (areGuardiansActive) {
    return ActionButtonState(
      isLoading: false,
      title: 'Reset',
      isEnabled: true,
    );
  }

  return ActionButtonState(
    isLoading: false,
    title: 'Activate',
    isEnabled: guardiansCount >= 2,
  );
}
