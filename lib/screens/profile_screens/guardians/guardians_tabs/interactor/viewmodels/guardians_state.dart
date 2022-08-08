part of 'guardians_bloc.dart';

class GuardiansState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final PageCommand? pageCommand;
  final bool isAddGuardianButtonLoading;
  final bool areGuardiansActive;
  final GuardiansConfigModel myGuardians;
  final ActionButtonState actionButtonState;

  const GuardiansState({
    required this.pageState,
    this.errorMessage,
    this.pageCommand,
    required this.areGuardiansActive,
    required this.isAddGuardianButtonLoading,
    required this.myGuardians,
    required this.actionButtonState,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        isAddGuardianButtonLoading,
        myGuardians,
        areGuardiansActive,
        actionButtonState,
      ];

  GuardiansState copyWith({
    PageState? pageState,
    String? errorMessage,
    PageCommand? pageCommand,
    int? indexDialog,
    bool? isAddGuardianButtonLoading,
    bool? areGuardiansActive,
    GuardiansConfigModel? myGuardians,
    ActionButtonState? actionButtonState,
  }) {
    return GuardiansState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      pageCommand: pageCommand,
      areGuardiansActive: areGuardiansActive ?? this.areGuardiansActive,
      isAddGuardianButtonLoading: isAddGuardianButtonLoading ?? this.isAddGuardianButtonLoading,
      myGuardians: myGuardians ?? this.myGuardians,
      actionButtonState: actionButtonState ?? this.actionButtonState,
    );
  }

  factory GuardiansState.initial() {
    return GuardiansState(
      pageState: PageState.initial,
      areGuardiansActive: false,
      isAddGuardianButtonLoading: false,
      actionButtonState: ActionButtonState(title: 'Activate', isEnabled: false, isLoading: false),
      myGuardians: GuardiansConfigModel.empty(),
    );
  }
}

class ActionButtonState {
  final String title;
  final bool isEnabled;
  final bool isLoading;

  ActionButtonState({required this.title, required this.isEnabled, required this.isLoading});
}
