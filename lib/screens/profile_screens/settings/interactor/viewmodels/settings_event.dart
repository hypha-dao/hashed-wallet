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

class ShouldShowNotificationBadge extends SettingsEvent {
  final bool value;
  const ShouldShowNotificationBadge({required this.value});
  @override
  String toString() => 'ShouldShowNotificationBadge { value: $value }';
}

class OnLoadingGuardians extends SettingsEvent {
  final List<GuardianModel> guardians;

  const OnLoadingGuardians({required this.guardians});
  @override
  String toString() => 'OnLoadingGuardians { guardians: $guardians }';
}

class OnGuardiansCardTapped extends SettingsEvent {
  const OnGuardiansCardTapped();
  @override
  String toString() => 'OnGuardiansCardTapped';
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
