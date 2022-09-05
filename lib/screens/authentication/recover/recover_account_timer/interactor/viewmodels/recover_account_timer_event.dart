part of 'recover_account_timer_bloc.dart';

abstract class RecoverAccountTimerEvent extends Equatable {
  const RecoverAccountTimerEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialData extends RecoverAccountTimerEvent {
  const FetchInitialData();

  @override
  String toString() => 'FetchInitialData';
}
