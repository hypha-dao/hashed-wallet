part of 'import_key_bloc.dart';

abstract class ImportKeyEvent extends Equatable {
  const ImportKeyEvent();

  @override
  List<Object?> get props => [];
}

class FindAccountByKey extends ImportKeyEvent {
  const FindAccountByKey();

  @override
  String toString() => 'FindAccountByKey';
}

class AccountSelected extends ImportKeyEvent {
  final String account;

  const AccountSelected({required this.account});

  @override
  String toString() => 'AccountSelected: { account: $account }';
}

class OnMneumonicPhraseChange extends ImportKeyEvent {
  final String newMneumonicPhrase;

  const OnMneumonicPhraseChange({required this.newMneumonicPhrase});

  @override
  String toString() => 'OnMneumonicPhraseChange: { inputChange: $newMneumonicPhrase }';
}

class ClearPageCommand extends ImportKeyEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
