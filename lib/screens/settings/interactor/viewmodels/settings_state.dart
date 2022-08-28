part of 'settings_bloc.dart';

enum CurrentChoice { initial, passcodeCard, biometricCard }

enum GuardiansStatus { active, inactive, readyToActivate }

class SettingsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final bool hasNotification;
  final bool showLogoutButton;
  final CurrentChoice currentChoice;
  final bool? isSecurePasscode;
  final bool? isSecureBiometric;
  final bool shouldShowExportRecoveryPhrase;

  const SettingsState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.hasNotification,
    required this.showLogoutButton,
    required this.currentChoice,
    this.isSecurePasscode,
    this.isSecureBiometric,
    required this.shouldShowExportRecoveryPhrase,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        hasNotification,
        showLogoutButton,
        currentChoice,
        isSecurePasscode,
        isSecureBiometric,
        shouldShowExportRecoveryPhrase,
      ];

  SettingsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    bool? hasNotification,
    bool? showLogoutButton,
    CurrentChoice? currentChoice,
    bool? isSecurePasscode,
    bool? isSecureBiometric,
    GuardiansStatus? guardiansStatus,
    bool? shouldShowExportRecoveryPhrase,
  }) {
    return SettingsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      hasNotification: hasNotification ?? this.hasNotification,
      showLogoutButton: showLogoutButton ?? this.showLogoutButton,
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
