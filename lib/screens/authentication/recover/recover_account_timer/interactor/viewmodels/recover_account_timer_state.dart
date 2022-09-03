part of 'recover_account_timer_bloc.dart';

class RecoverAccountTimerState extends Equatable {
  final PageState pageState;
  final String userAccount;
  final PageCommand? pageCommand;

  const RecoverAccountTimerState({
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

  RecoverAccountTimerState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
  }) {
    return RecoverAccountTimerState(
      pageState: pageState ?? this.pageState,
      userAccount: userAccount,
      pageCommand: pageCommand,
    );
  }

  factory RecoverAccountTimerState.initial(String userAccount) {
    return RecoverAccountTimerState(
      pageState: PageState.initial,
      userAccount: userAccount,
    );
  }
}
