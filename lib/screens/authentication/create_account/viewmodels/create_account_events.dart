part of 'create_account_bloc.dart';

abstract class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();

  @override
  List<Object?> get props => [];
}

class OnCreateNameNext extends CreateAccountEvent {
  const OnCreateNameNext();

  @override
  String toString() => 'OnCreateNameNext';
}

class SubmitName extends CreateAccountEvent {
  const SubmitName();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'SubmitName';
}

class ClearPageCommand extends CreateAccountEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
