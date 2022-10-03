part of 'recover_account_search_bloc.dart';

abstract class RecoverAccountSearchEvent extends Equatable {
  const RecoverAccountSearchEvent();

  @override
  List<Object?> get props => [];
}

class OnAccountChanged extends RecoverAccountSearchEvent {
  final String account;

  const OnAccountChanged(this.account);

  @override
  String toString() => 'OnAccountChanged { account: $account}';
}

class OnNextButtonTapped extends RecoverAccountSearchEvent {
  const OnNextButtonTapped();

  @override
  String toString() => 'OnNextButtonTapped';
}

class OnConfirmRecoverTapped extends RecoverAccountSearchEvent {
  const OnConfirmRecoverTapped();

  @override
  String toString() => 'OnConfirmRecoverTapped';
}

class ClearPageCommand extends RecoverAccountSearchEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
