part of 'import_key_bloc.dart';

abstract class ImportKeyEvent extends Equatable {
  const ImportKeyEvent();

  @override
  List<Object?> get props => [];
}

class GetAccountByKey extends ImportKeyEvent {
  const GetAccountByKey();

  @override
  String toString() => 'FindAccountByKey';
}

class AccountSelected extends ImportKeyEvent {
  final String account;

  const AccountSelected({required this.account});

  @override
  String toString() => 'AccountSelected: { account: $account }';
}

class OnMnemonicPhraseChange extends ImportKeyEvent {
  final String newMnemonicPhrase;

  const OnMnemonicPhraseChange({required this.newMnemonicPhrase});

  @override
  String toString() => 'OnMnemonicPhraseChange: { inputChange: $newMnemonicPhrase }';
}

class ClearPageCommand extends ImportKeyEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
