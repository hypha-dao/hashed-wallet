part of 'scan_confirmation_bloc.dart';

class ScanConfirmationState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final bool actionButtonLoading;
  final String? transactionSendError;

  const ScanConfirmationState({
    required this.pageState,
    this.pageCommand,
    required this.actionButtonLoading,
    this.transactionSendError,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        actionButtonLoading,
        transactionSendError,
      ];

  ScanConfirmationState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    bool? actionButtonLoading,
    String? transactionSendError,
  }) {
    return ScanConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      actionButtonLoading: actionButtonLoading ?? this.actionButtonLoading,
      transactionSendError: transactionSendError ?? this.transactionSendError,
    );
  }

  factory ScanConfirmationState.initial() {
    return const ScanConfirmationState(
      pageState: PageState.initial,
      actionButtonLoading: false,
    );
  }
}
