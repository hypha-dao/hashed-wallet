part of 'recover_account_timer_bloc.dart';

abstract class RecoverAccountTimerEvent extends Equatable {
  const RecoverAccountTimerEvent();

  @override
  List<Object?> get props => [];
}

class FetchTimerData extends RecoverAccountTimerEvent {
  final bool showLoadingIndicator;
  const FetchTimerData(this.showLoadingIndicator);

  @override
  String toString() => 'FetchInitialData';
}

class OnRefreshTapped extends RecoverAccountTimerEvent {
  const OnRefreshTapped();

  @override
  String toString() => 'OnRefreshTapped';
}

class OnRecoverTapped extends RecoverAccountTimerEvent {
  const OnRecoverTapped();

  @override
  String toString() => 'OnRecoverTapped';
}

class Tick extends RecoverAccountTimerEvent {
  final int count;

  const Tick(this.count);

  @override
  List<Object?> get props => [count];

  @override
  String toString() => 'Tick { $count }';
}
