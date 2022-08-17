import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/guardian_notification_use_case.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/settings/interactor/viewmodels/page_commands.dart';
import 'package:share/share.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  SettingsBloc(this._authenticationBloc) : super(SettingsState.initial(false)) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

    on<SetUpInitialValues>(_setUpInitialValues);
    on<ShouldShowNotificationBadge>((event, emit) => emit(state.copyWith(hasNotification: event.value)));
    on<OnGuardiansCardTapped>(_onGuardiansCardTapped);
    on<OnRecoverAccountTapped>(_onRecoverAccountTapped);
    on<OnExportPrivateKeyCardTapped>(
        (event, emit) => emit(state.copyWith(pageCommand: NavigateToRoute(Routes.exportPrivateKey))));
    on<OnPasscodePressed>(_onPasscodePressed);
    on<OnBiometricPressed>(_onBiometricPressed);
    on<ResetNavigateToVerification>((_, emit) => emit(state.copyWith()));
    on<OnValidVerification>(_onValidVerification);
    on<OnLogoutButtonPressed>(_onLogoutButtonPressed);
    on<ClearSettingsPageCommand>((_, emit) => emit(state.copyWith()));
    on<OnSaveRecoveryPhraseButtonPressed>(_onSaveRecoveryPhraseButtonPressed);
    on<ResetShowLogoutButton>((_, emit) => emit(state.copyWith(showLogoutButton: false)));
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

  Future<void> _onRecoverAccountTapped(OnRecoverAccountTapped event, Emitter<SettingsState> emit) async {
    emit(state.copyWith()); //reset
    emit(state.copyWith(navigateToRecoverAccount: true));
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

  void _onLogoutButtonPressed(OnLogoutButtonPressed event, Emitter<SettingsState> emit) {
    emit(state.copyWith(pageCommand: ShowLogoutRecoveryPhraseDialog()));
  }

  Future<void> _onSaveRecoveryPhraseButtonPressed(
      OnSaveRecoveryPhraseButtonPressed event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(showLogoutButton: true));
    final String? words = await accountService.getCurrentPrivateKey();
    if (words != null) {
      await Share.share(words);
    }
    settingsStorage.savePrivateKeyBackedUp(true);
  }
}
