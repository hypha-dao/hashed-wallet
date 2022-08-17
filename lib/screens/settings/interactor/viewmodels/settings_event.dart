part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SetUpInitialValues extends SettingsEvent {
  const SetUpInitialValues();
  @override
  String toString() => 'SetUpInitialValues';
}

class OnExportPrivateKeyCardTapped extends SettingsEvent {
  const OnExportPrivateKeyCardTapped();
  @override
  String toString() => 'OnExportPrivateKeyCardTapped';
}

class ShouldShowNotificationBadge extends SettingsEvent {
  final bool value;
  const ShouldShowNotificationBadge({required this.value});
  @override
  String toString() => 'ShouldShowNotificationBadge { value: $value }';
}

class OnLoadingGuardians extends SettingsEvent {
  final List<Account> guardians;

  const OnLoadingGuardians({required this.guardians});
  @override
  String toString() => 'OnLoadingGuardians { guardians: $guardians }';
}

class OnGuardiansCardTapped extends SettingsEvent {
  const OnGuardiansCardTapped();
  @override
  String toString() => 'OnGuardiansCardTapped';
}

class OnRecoverAccountTapped extends SettingsEvent {
  const OnRecoverAccountTapped();
  @override
  String toString() => 'OnRecoverAccountTapped';
}

class OnPasscodePressed extends SettingsEvent {
  const OnPasscodePressed();
  @override
  String toString() => 'OnPasscodePressed';
}

class OnBiometricPressed extends SettingsEvent {
  const OnBiometricPressed();
  @override
  String toString() => 'OnBiometricPressed';
}

class ResetNavigateToVerification extends SettingsEvent {
  const ResetNavigateToVerification();
  @override
  String toString() => 'ResetNavigateToVerification';
}

class OnValidVerification extends SettingsEvent {
  const OnValidVerification();
  @override
  String toString() => 'OnValidVerification';
}

class OnLogoutButtonPressed extends SettingsEvent {
  const OnLogoutButtonPressed();
  @override
  String toString() => 'OnLogoutButtonPressed';
}

class ClearSettingsPageCommand extends SettingsEvent {
  const ClearSettingsPageCommand();

  @override
  String toString() => 'ClearProfilePageCommand';
}

class OnSaveRecoveryPhraseButtonPressed extends SettingsEvent {
  const OnSaveRecoveryPhraseButtonPressed();

  @override
  String toString() => 'OnSaveRecoveryPhraseButtonPressed';
}

class ResetShowLogoutButton extends SettingsEvent {
  const ResetShowLogoutButton();

  @override
  String toString() => 'ResetShowLogoutButton';
}
