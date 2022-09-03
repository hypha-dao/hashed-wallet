part of 'recover_account_success_bloc.dart';

class RecoverAccountSuccessState extends Equatable {
  final PageState pageState;
  final String userAccount;
  final PageCommand? pageCommand;

  const RecoverAccountSuccessState({
    required this.pageState,
    required this.userAccount,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        userAccount,
        pageCommand,
      ];

  RecoverAccountSuccessState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
  }) {
    return RecoverAccountSuccessState(
      pageState: pageState ?? this.pageState,
      userAccount: userAccount,
      pageCommand: pageCommand,
    );
  }

  factory RecoverAccountSuccessState.initial(String userAccount) {
    return RecoverAccountSuccessState(
      pageState: PageState.initial,
      userAccount: userAccount,
    );
  }
}
