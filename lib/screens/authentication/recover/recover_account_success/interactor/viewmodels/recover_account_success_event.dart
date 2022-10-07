part of 'recover_account_success_bloc.dart';

abstract class RecoverAccountSuccessEvent extends Equatable {
  const RecoverAccountSuccessEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialData extends RecoverAccountSuccessEvent {
  const FetchInitialData();

  @override
  String toString() => 'FetchInitialData';
}

class OnRefreshTapped extends RecoverAccountSuccessEvent {
  const OnRefreshTapped();

  @override
  String toString() => 'OnRefreshTapped';
}

class OnRecoverFundsTapped extends RecoverAccountSuccessEvent {
  final String rescuer;
  final String lostAccount;
  const OnRecoverFundsTapped({required this.rescuer, required this.lostAccount});

  @override
  String toString() => 'OnRecoverFundsTapped';
}

class OnCleanupAndRemoveTapped extends RecoverAccountSuccessEvent {
  const OnCleanupAndRemoveTapped();

  @override
  String toString() => 'OnCleanupAndRemoveTapped';
}

class OnRemoveActiveRecoveryTapped extends RecoverAccountSuccessEvent {
  const OnRemoveActiveRecoveryTapped();

  @override
  String toString() => 'OnRemoveActiveRecoveryTapped';
}

class OnRemoveGuardiansConfigTapped extends RecoverAccountSuccessEvent {
  const OnRemoveGuardiansConfigTapped();

  @override
  String toString() => 'OnRemoveGuardiansConfigTapped';
}
