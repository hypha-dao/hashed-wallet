part of 'recover_account_timer_bloc.dart';

class RecoverAccountTimerState extends Equatable {
  final PageState pageState;
  final ActiveRecoveryModel recoveryModel;
  final CurrentRemainingTime? currentRemainingTime;
  final PageCommand? pageCommand;
  final int timeLockExpirySeconds;

  int get timeRemaining => timeLockExpirySeconds - DateTime.now().millisecondsSinceEpoch ~/ 1000;

  const RecoverAccountTimerState({
    required this.pageState,
    required this.recoveryModel,
    this.pageCommand,
    required this.currentRemainingTime,
    required this.timeLockExpirySeconds,
  });

  @override
  List<Object?> get props => [
        pageState,
        recoveryModel,
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
      recoveryModel: recoveryModel,
      pageCommand: pageCommand,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      timeLockExpirySeconds: timeLockExpirySeconds ?? this.timeLockExpirySeconds,
    );
  }

  factory RecoverAccountTimerState.initial(ActiveRecoveryModel recoveryModel) {
    return RecoverAccountTimerState(
      pageState: PageState.initial,
      recoveryModel: recoveryModel,
      currentRemainingTime: CurrentRemainingTime.zero(),
      timeLockExpirySeconds: 0,
    );
  }
}
