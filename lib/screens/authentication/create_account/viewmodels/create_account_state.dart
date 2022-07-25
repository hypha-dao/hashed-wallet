part of 'create_account_bloc.dart';

enum CreateAccountScreens { createName, mnemonicSeed }

class CreateAccountState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String name;
  final PageCommand? pageCommand;
  final CreateAccountScreens currentScreen;

  const CreateAccountState({
    required this.pageState,
    this.errorMessage,
    required this.name,
    this.pageCommand,
    required this.currentScreen,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        name,
        pageCommand,
        currentScreen,
      ];

  CreateAccountState copyWith({
    PageState? pageState,
    String? errorMessage,
    String? name,
    PageCommand? pageCommand,
    CreateAccountScreens? currentScreen,
  }) {
    return CreateAccountState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      name: name ?? this.name,
      pageCommand: pageCommand,
      currentScreen: currentScreen ?? this.currentScreen,
    );
  }

  factory CreateAccountState.initial() {
    return const CreateAccountState(
      pageState: PageState.initial,
      name: '',
      currentScreen: CreateAccountScreens.createName,
    );
  }
}
