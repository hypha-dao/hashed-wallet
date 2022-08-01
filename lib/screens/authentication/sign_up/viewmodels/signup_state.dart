part of 'signup_bloc.dart';

enum SignupScreens { displayName, createAccount }

class SignupState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final SignUpError? error;
  final SignupScreens signupScreens;
  final String? accountName;
  final String? displayName;
  final AuthDataModel? auth;

  const SignupState({
    required this.pageState,
    this.pageCommand,
    this.error,
    required this.signupScreens,
    this.accountName,
    this.displayName,
    this.auth,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        error,
        signupScreens,
        accountName,
        displayName,
      ];

  bool get isUsernameValid => !accountName.isNullOrEmpty && pageState == PageState.success;

  bool get isNextButtonActive => isUsernameValid;

  SignupState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    SignUpError? error,
    SignupScreens? signupScreens,
    String? accountName,
    String? displayName,
  }) =>
      SignupState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        error: error,
        signupScreens: signupScreens ?? this.signupScreens,
        accountName: accountName ?? this.accountName,
        displayName: displayName ?? this.displayName,
      );

  factory SignupState.initial() {
    return const SignupState(
      pageState: PageState.initial,
      signupScreens: SignupScreens.displayName,
    );
  }
}
