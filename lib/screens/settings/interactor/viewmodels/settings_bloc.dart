import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/guardian_notification_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/should_show_recovery_phrase_features_use_case.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  SettingsBloc(this._authenticationBloc)
      : super(SettingsState.initial(ShouldShowRecoveryPhraseFeatureUseCase().shouldShowRecoveryPhrase())) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

    on<SetUpInitialValues>(_setUpInitialValues);
    on<ShouldShowNotificationBadge>((event, emit) => emit(state.copyWith(hasNotification: event.value)));
    on<OnGuardiansCardTapped>(_onGuardiansCardTapped);
    on<OnPasscodePressed>(_onPasscodePressed);
    on<OnBiometricPressed>(_onBiometricPressed);
    on<ResetNavigateToVerification>((_, emit) => emit(state.copyWith()));
    on<OnValidVerification>(_onValidVerification);
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    return super.close();
  }

  Stream<bool> get isGuardianContractInitialized {
    return _repository.isGuardiansInitialized(accountService.currentAccount.address);
  }

  void _setUpInitialValues(SetUpInitialValues event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
      pageState: PageState.success,
      isSecurePasscode: settingsStorage.passcodeActive,
      isSecureBiometric: settingsStorage.biometricActive,
    ));
  }

  Future<void> _onGuardiansCardTapped(OnGuardiansCardTapped event, Emitter<SettingsState> emit) async {
    emit(state.copyWith()); //reset
    if (state.hasNotification) {
      await FirebaseDatabaseGuardiansRepository().removeGuardianNotification(accountService.currentAccount.address);
    }
    emit(state.copyWith(navigateToGuardians: true));
  }

  void _onPasscodePressed(OnPasscodePressed event, Emitter<SettingsState> emit) {
    emit(state.copyWith(navigateToVerification: true, currentChoice: CurrentChoice.passcodeCard));
  }

  void _onBiometricPressed(OnBiometricPressed event, Emitter<SettingsState> emit) {
    if (state.isSecureBiometric!) {
      emit(state.copyWith(navigateToVerification: true, currentChoice: CurrentChoice.biometricCard));
    } else {
      emit(state.copyWith(isSecureBiometric: true));
      _authenticationBloc.add(const EnableBiometric());
    }
  }

  void _onValidVerification(OnValidVerification event, Emitter<SettingsState> emit) {
    switch (state.currentChoice) {
      case CurrentChoice.passcodeCard:
        if (state.isSecurePasscode!) {
          emit(state.copyWith(isSecurePasscode: false, isSecureBiometric: false));
          _authenticationBloc.add(const DisablePasscode());
        } else {
          emit(state.copyWith(isSecurePasscode: true));
        }
        break;
      case CurrentChoice.biometricCard:
        emit(state.copyWith(isSecureBiometric: false));
        _authenticationBloc.add(const DisableBiometric());
        break;
      default:
        return;
    }
  }
}
