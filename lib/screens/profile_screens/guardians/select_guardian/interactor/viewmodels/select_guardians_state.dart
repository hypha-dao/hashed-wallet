part of 'select_guardians_bloc.dart';

const maxGuardiansAllowed = 5;

class SelectGuardiansState extends Equatable {
  final PageState pageState;
  final List<GuardianModel> myGuardians;
  final PageCommand? pageCommand;

  const SelectGuardiansState({
    required this.pageState,
    required this.myGuardians,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        myGuardians,
      ];

  SelectGuardiansState copyWith({
    PageState? pageState,
    String? pageTitle,
    PageCommand? pageCommand,
  }) {
    return SelectGuardiansState(
      pageState: pageState ?? this.pageState,
      myGuardians: myGuardians,
      pageCommand: pageCommand,
    );
  }

  factory SelectGuardiansState.initial(List<GuardianModel> myGuardians) {
    final List<String> noShowGuardians = myGuardians.map((GuardianModel e) => e.walletAddress).toList();
    noShowGuardians.add(settingsStorage.accountName);

    return SelectGuardiansState(
      pageState: PageState.initial,
      myGuardians: myGuardians,
    );
  }
}
