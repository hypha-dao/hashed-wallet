part of 'recover_account_details_bloc.dart';

abstract class RecoverAccountDetailsEvent extends Equatable {
  const RecoverAccountDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialData extends RecoverAccountDetailsEvent {
  const FetchInitialData();

  @override
  String toString() => 'FetchInitialData';
}
