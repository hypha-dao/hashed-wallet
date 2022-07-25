part of 'select_guardians_bloc.dart';

class SelectGuardiansState extends Equatable {
  final PageState pageState;
  final String? guardianKey;
  final String? guardianName;
  final PageCommand? pageCommand;
  final bool isActionButtonLoading;

  const SelectGuardiansState({
    required this.pageState,
    this.guardianKey,
    this.guardianName,
    this.pageCommand,
    required this.isActionButtonLoading,
  });

  bool get isActionButtonEnabled => !isActionButtonLoading && !guardianKey.isNullOrEmpty;

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        guardianName,
        guardianKey,
        isActionButtonLoading,
      ];

  SelectGuardiansState copyWith({
    PageState? pageState,
    String? pageTitle,
    String? guardianKey,
    String? guardianName,
    PageCommand? pageCommand,
    bool? isActionButtonLoading,
  }) {
    return SelectGuardiansState(
      pageState: pageState ?? this.pageState,
      guardianKey: guardianKey ?? this.guardianKey,
      guardianName: guardianName ?? this.guardianName,
      pageCommand: pageCommand,
      isActionButtonLoading: isActionButtonLoading ?? this.isActionButtonLoading,
    );
  }

  factory SelectGuardiansState.initial() {
    return const SelectGuardiansState(
      pageState: PageState.initial,
      isActionButtonLoading: false,
    );
  }
}
