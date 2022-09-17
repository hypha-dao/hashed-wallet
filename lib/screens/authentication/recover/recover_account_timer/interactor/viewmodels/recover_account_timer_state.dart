part of 'recover_account_timer_bloc.dart';

class RecoverAccountTimerState extends Equatable {
  final PageState pageState;
  final String userAccount;
  final CurrentRemainingTime? currentRemainingTime;
  final PageCommand? pageCommand;
  final int timeLockExpirySeconds;

  int get timeRemaining => timeLockExpirySeconds - DateTime.now().millisecondsSinceEpoch ~/ 1000;

  const RecoverAccountTimerState({
    required this.pageState,
    required this.userAccount,
    this.pageCommand,
    required this.currentRemainingTime,
    required this.timeLockExpirySeconds,
  });

  @override
  List<Object?> get props => [
        pageState,
        userAccount,
        pageCommand,
        currentRemainingTime,
        timeLockExpirySeconds,
      ];

  RecoverAccountTimerState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CurrentRemainingTime? currentRemainingTime,
    int? timeLockExpirySeconds,
  }) {
    return RecoverAccountTimerState(
      pageState: pageState ?? this.pageState,
      userAccount: userAccount,
      pageCommand: pageCommand,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      timeLockExpirySeconds: timeLockExpirySeconds ?? this.timeLockExpirySeconds,
    );
  }

  factory RecoverAccountTimerState.initial(String userAccount) {
    return RecoverAccountTimerState(
      pageState: PageState.initial,
      userAccount: userAccount,
      currentRemainingTime: CurrentRemainingTime.zero(),
      timeLockExpirySeconds: 0,
    );
  }
}
