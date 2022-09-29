part of 'recover_account_timer_bloc.dart';

class RecoverAccountTimerState extends Equatable {
  final PageState pageState;
  final ActiveRecoveryModel recoveryModel;
  final GuardiansConfigModel configModel;
  final CurrentRemainingTime? currentRemainingTime;
  final PageCommand? pageCommand;
  final DateTime timeLockExpirationDate;

  int get timeRemainingSeconds => timeLockExpirationDate.difference(DateTime.now()).inSeconds;

  const RecoverAccountTimerState({
    required this.pageState,
    required this.recoveryModel,
    required this.configModel,
    this.pageCommand,
    required this.currentRemainingTime,
    required this.timeLockExpirationDate,
  });

  @override
  List<Object?> get props => [
        pageState,
        recoveryModel,
        pageCommand,
        currentRemainingTime,
        timeLockExpirationDate,
      ];

  RecoverAccountTimerState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CurrentRemainingTime? currentRemainingTime,
    DateTime? timeLockExpirationDate,
  }) {
    return RecoverAccountTimerState(
      pageState: pageState ?? this.pageState,
      recoveryModel: recoveryModel,
      configModel: configModel,
      pageCommand: pageCommand,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      timeLockExpirationDate: timeLockExpirationDate ?? this.timeLockExpirationDate,
    );
  }

  factory RecoverAccountTimerState.initial(ActiveRecoveryModel recoveryModel, GuardiansConfigModel configModel) {
    return RecoverAccountTimerState(
      pageState: PageState.initial,
      recoveryModel: recoveryModel,
      configModel: configModel,
      currentRemainingTime: CurrentRemainingTime.zero(),
      timeLockExpirationDate: DateTime.now(),
    );
  }
}
