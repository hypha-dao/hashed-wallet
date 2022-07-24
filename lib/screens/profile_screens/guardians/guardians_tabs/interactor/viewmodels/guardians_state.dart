part of 'guardians_bloc.dart';

class GuardiansState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final PageCommand? pageCommand;
  final int indexDialog;
  final bool isAddGuardianButtonLoading;
  final List<GuardianModel> myGuardians;

  const GuardiansState({
    required this.pageState,
    this.errorMessage,
    this.pageCommand,
    required this.indexDialog,
    required this.isAddGuardianButtonLoading,
    required this.myGuardians,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        indexDialog,
        errorMessage,
        isAddGuardianButtonLoading,
        myGuardians,
      ];

  GuardiansState copyWith({
    PageState? pageState,
    String? errorMessage,
    PageCommand? pageCommand,
    int? indexDialog,
    bool? isAddGuardianButtonLoading,
    List<GuardianModel>? myGuardians,
  }) {
    return GuardiansState(
        pageState: pageState ?? this.pageState,
        errorMessage: errorMessage,
        pageCommand: pageCommand,
        indexDialog: indexDialog ?? this.indexDialog,
        isAddGuardianButtonLoading: isAddGuardianButtonLoading ?? this.isAddGuardianButtonLoading,
        myGuardians: myGuardians ?? this.myGuardians);
  }

  factory GuardiansState.initial() {
    return const GuardiansState(
      pageState: PageState.initial,
      indexDialog: 1,
      isAddGuardianButtonLoading: false,
      myGuardians: [],
    );
  }
}
