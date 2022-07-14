part of 'settings_bloc.dart';

enum CurrentChoice { initial, passcodeCard, biometricCard }
enum GuardiansStatus { active, inactive, readyToActivate }

class SettingsState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool hasNotification;
  final bool? navigateToGuardians;
  final bool? navigateToVerification;
  final CurrentChoice currentChoice;
  final bool? isSecurePasscode;
  final bool? isSecureBiometric;
  final GuardiansStatus? guardiansStatus;
  final bool shouldShowExportRecoveryPhrase;

  const SettingsState({
    required this.pageState,
    this.errorMessage,
    required this.hasNotification,
    this.navigateToGuardians,
    this.navigateToVerification,
    required this.currentChoice,
    this.isSecurePasscode,
    this.isSecureBiometric,
    this.guardiansStatus,
    required this.shouldShowExportRecoveryPhrase,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        hasNotification,
        navigateToGuardians,
        navigateToVerification,
        currentChoice,
        isSecurePasscode,
        isSecureBiometric,
        guardiansStatus,
        shouldShowExportRecoveryPhrase,
      ];

  SettingsState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? hasNotification,
    bool? navigateToGuardians,
    bool? navigateToVerification,
    CurrentChoice? currentChoice,
    bool? isSecurePasscode,
    bool? isSecureBiometric,
    GuardiansStatus? guardiansStatus,
    bool? shouldShowExportRecoveryPhrase,
  }) {
    return SettingsState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      hasNotification: hasNotification ?? this.hasNotification,
      navigateToGuardians: navigateToGuardians,
      navigateToVerification: navigateToVerification,
      currentChoice: currentChoice ?? this.currentChoice,
      isSecurePasscode: isSecurePasscode ?? this.isSecurePasscode,
      isSecureBiometric: isSecureBiometric ?? this.isSecureBiometric,
      guardiansStatus: guardiansStatus ?? this.guardiansStatus,
      shouldShowExportRecoveryPhrase: shouldShowExportRecoveryPhrase ?? this.shouldShowExportRecoveryPhrase,
    );
  }

  factory SettingsState.initial(bool shouldShowRecoveryWordsFeature) {
    return SettingsState(
        pageState: PageState.initial,
        currentChoice: CurrentChoice.initial,
        hasNotification: false,
        shouldShowExportRecoveryPhrase: shouldShowRecoveryWordsFeature);
  }
}
