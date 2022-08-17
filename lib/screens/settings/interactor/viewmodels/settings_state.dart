part of 'settings_bloc.dart';

enum CurrentChoice { initial, passcodeCard, biometricCard }

enum GuardiansStatus { active, inactive, readyToActivate }

class SettingsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final bool hasNotification;
  final bool? navigateToGuardians;
  final bool showLogoutButton;
  final bool? navigateToVerification;
  final CurrentChoice currentChoice;
  final bool? isSecurePasscode;
  final bool? isSecureBiometric;
  final bool shouldShowExportRecoveryPhrase;
  final bool? navigateToRecoverAccount;

  const SettingsState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.hasNotification,
    this.navigateToGuardians,
    required this.showLogoutButton,
    this.navigateToVerification,
    required this.currentChoice,
    this.isSecurePasscode,
    this.isSecureBiometric,
    required this.shouldShowExportRecoveryPhrase,
    this.navigateToRecoverAccount,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        hasNotification,
        navigateToGuardians,
        showLogoutButton,
        navigateToVerification,
        currentChoice,
        isSecurePasscode,
        isSecureBiometric,
        shouldShowExportRecoveryPhrase,
        navigateToRecoverAccount,
      ];

  SettingsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    bool? hasNotification,
    bool? navigateToGuardians,
    bool? showLogoutButton,
    bool? navigateToVerification,
    CurrentChoice? currentChoice,
    bool? isSecurePasscode,
    bool? isSecureBiometric,
    GuardiansStatus? guardiansStatus,
    bool? shouldShowExportRecoveryPhrase,
    bool? navigateToRecoverAccount,
  }) {
    return SettingsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      hasNotification: hasNotification ?? this.hasNotification,
      navigateToGuardians: navigateToGuardians,
      showLogoutButton: showLogoutButton ?? this.showLogoutButton,
      navigateToVerification: navigateToVerification,
      navigateToRecoverAccount: navigateToRecoverAccount,
      currentChoice: currentChoice ?? this.currentChoice,
      isSecurePasscode: isSecurePasscode ?? this.isSecurePasscode,
      isSecureBiometric: isSecureBiometric ?? this.isSecureBiometric,
      shouldShowExportRecoveryPhrase: shouldShowExportRecoveryPhrase ?? this.shouldShowExportRecoveryPhrase,
    );
  }

  factory SettingsState.initial(bool shouldShowRecoveryWordsFeature) {
    return SettingsState(
        pageState: PageState.initial,
        currentChoice: CurrentChoice.initial,
        showLogoutButton: false,
        hasNotification: false,
        shouldShowExportRecoveryPhrase: shouldShowRecoveryWordsFeature);
  }
}
