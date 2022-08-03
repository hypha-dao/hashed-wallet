part of 'import_key_bloc.dart';

class ImportKeyState extends Equatable {
  final String? error;
  final AuthDataModel? authData;
  final List<ProfileModel> accounts;
  final String mneumonicPhrase;
  final bool isButtonLoading;
  final bool enableButton;
  final String? accountSelected;
  final PageCommand? pageCommand;

  const ImportKeyState({
    this.error,
    required this.accounts,
    required this.mneumonicPhrase,
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
        mneumonicPhrase,
        isButtonLoading,
        enableButton,
        accountSelected,
        pageCommand,
      ];

  ImportKeyState copyWith({
    PageState? pageState,
    String? error,
    List<ProfileModel>? accounts,
    String? mneumonicPhrase,
    bool? isButtonLoading,
    AuthDataModel? authData,
    bool? enableButton,
    String? accountSelected,
    PageCommand? pageCommand,
  }) {
    return ImportKeyState(
        error: error,
        accounts: accounts ?? this.accounts,
        mneumonicPhrase: mneumonicPhrase ?? this.mneumonicPhrase,
        isButtonLoading: isButtonLoading ?? this.isButtonLoading,
        authData: authData ?? this.authData,
        enableButton: enableButton ?? this.enableButton,
        accountSelected: accountSelected,
        pageCommand: pageCommand);
  }

  factory ImportKeyState.initial() {
    return const ImportKeyState(
      accounts: [],
      mneumonicPhrase: "",
      enableButton: false,
      isButtonLoading: false,
    );
  }
}
