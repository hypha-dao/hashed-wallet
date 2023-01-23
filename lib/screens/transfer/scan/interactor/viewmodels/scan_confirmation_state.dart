part of 'scan_confirmation_bloc.dart';

final mockData = [
  ScanConfirmationActionWidget(
    data: ScanConfirmationActionData(pallet: "Recovery", extrinsic: "CreateRecovery", actionParams: {
      'first': 'First Name',
      'second': 'second name',
      'third': 'Third =Nik',
    }),
  ),
  ScanConfirmationActionWidget(
    data: ScanConfirmationActionData(
      pallet: "Recovery",
      extrinsic: "CreateRecovery",
      actionParams: {
        'Parameter 1': 'doe_john',
        'Parameter 2': 'butt_roman12',
      },
    ),
  ),
  ScanConfirmationActionWidget(
      data: ScanConfirmationActionData(
    pallet: "Recovery",
    extrinsic: "CreateRecovery",
    actionParams: {
      'Parameter 1': 'doe_john',
      'Parameter 2': 'butt_roman12',
      'Parameter 3': 'Bill split payment of last week',
    },
  )),
];

class ScanConfirmationState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final bool actionButtonLoading;
  final String? transactionSendError;
  final List<ScanConfirmationActionData>? actions;

  const ScanConfirmationState(
      {required this.pageState,
      this.pageCommand,
      required this.actionButtonLoading,
      this.transactionSendError,
      this.actions});

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
    List<ScanConfirmationActionData>? actions,
  }) {
    return ScanConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      actionButtonLoading: actionButtonLoading ?? this.actionButtonLoading,
      transactionSendError: transactionSendError ?? this.transactionSendError,
      actions: actions ?? this.actions,
    );
  }

  factory ScanConfirmationState.initial() {
    return const ScanConfirmationState(
      pageState: PageState.initial,
      actionButtonLoading: false,
    );
  }
}
