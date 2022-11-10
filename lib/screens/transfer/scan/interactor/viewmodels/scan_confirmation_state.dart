part of 'scan_confirmation_bloc.dart';

class ScanConfirmationState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final bool actionButtonLoading;

  const ScanConfirmationState({
    required this.pageState,
    this.pageCommand,
    required this.actionButtonLoading,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        actionButtonLoading,
      ];

  ScanConfirmationState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    bool? actionButtonLoading,
  }) {
    return ScanConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      actionButtonLoading: actionButtonLoading ?? this.actionButtonLoading,
    );
  }

  factory ScanConfirmationState.initial() {
    return const ScanConfirmationState(
      pageState: PageState.initial,
      actionButtonLoading: false,
    );
  }
}
