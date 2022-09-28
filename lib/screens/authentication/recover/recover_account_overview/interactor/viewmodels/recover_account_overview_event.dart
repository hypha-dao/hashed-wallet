part of 'recover_account_overview_bloc.dart';

abstract class RecoverAccountOverviewEvent extends Equatable {
  const RecoverAccountOverviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialData extends RecoverAccountOverviewEvent {
  const FetchInitialData();

  @override
  String toString() => 'FetchInitialData';
}

class OnRefreshTapped extends RecoverAccountOverviewEvent {
  const OnRefreshTapped();

  @override
  String toString() => 'OnRefreshTapped';
}

class OnRecoverAccountTapped extends RecoverAccountOverviewEvent {
  const OnRecoverAccountTapped();

  @override
  String toString() => 'OnRecoverAccountTapped';
}

class OnRecoveryInProcessTapped extends RecoverAccountOverviewEvent {
  final String lostAccount;
  const OnRecoveryInProcessTapped(this.lostAccount);

  @override
  String toString() => 'OnRecoveryInProcessTapped';
}
