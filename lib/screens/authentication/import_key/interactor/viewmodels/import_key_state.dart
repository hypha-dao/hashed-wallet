part of 'import_key_bloc.dart';

class ImportKeyState extends Equatable {
  final String? error;
  final AuthDataModel? authData;
  final List<String> accounts;
  final String mnemonicPhrase;
  final bool isButtonLoading;
  final bool enableButton;
  final String? accountSelected;
  final PageCommand? pageCommand;

  const ImportKeyState({
    this.error,
    required this.accounts,
    required this.mnemonicPhrase,
    required this.isButtonLoading,
    this.authData,
    required this.enableButton,
    this.accountSelected,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        error,
        authData,
        accounts,
        mnemonicPhrase,
        isButtonLoading,
        enableButton,
        accountSelected,
        pageCommand,
      ];

  ImportKeyState copyWith({
    PageState? pageState,
    String? error,
    List<String>? accounts,
    String? mnemonicPhrase,
    bool? isButtonLoading,
    AuthDataModel? authData,
    bool? enableButton,
    String? accountSelected,
    PageCommand? pageCommand,
  }) {
    return ImportKeyState(
        error: error,
        accounts: accounts ?? this.accounts,
        mnemonicPhrase: mnemonicPhrase ?? this.mnemonicPhrase,
        isButtonLoading: isButtonLoading ?? this.isButtonLoading,
        authData: authData ?? this.authData,
        enableButton: enableButton ?? this.enableButton,
        accountSelected: accountSelected,
        pageCommand: pageCommand);
  }

  factory ImportKeyState.initial() {
    return const ImportKeyState(
      accounts: [],
      mnemonicPhrase: "",
      enableButton: false,
      isButtonLoading: false,
    );
  }
}
