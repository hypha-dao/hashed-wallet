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
