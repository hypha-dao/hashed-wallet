import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/design/lib/hashed_body_widget.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/images/explore/red_exclamation_circle.dart';
import 'package:hashed/screens/transfer/scan/components/scan_transaction_success_dialog.dart';
import 'package:hashed/screens/transfer/scan/interactor/viewmodels/scan_confirmation_bloc.dart';
import 'package:hashed/screens/transfer/scan/interactor/viewmodels/scan_confirmation_commands.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_action.dart';

final mockData = [
  ScanConfirmationAction(
      data: ScanConfirmationActionData(actionName: const MapEntry('CreateRecovery', 'Recovery'), actionParams: {
    'first': 'First Name',
    'second': 'second name',
    'third': 'Third =Nik',
  })),
  ScanConfirmationAction(
      data: ScanConfirmationActionData(actionName: const MapEntry('CreateRecovery', 'Recovery'), actionParams: {
    'Parameter 1': 'doe_john',
    'Parameter 2': 'butt_roman12',
  })),
  ScanConfirmationAction(
      data: ScanConfirmationActionData(actionName: const MapEntry('CreateRecovery', 'Recovery'), actionParams: {
    'Parameter 1': 'doe_john',
    'Parameter 2': 'butt_roman12',
    'Parameter 3': 'Bill split payment of last week',
  })),
];

class ScanConfirmationScreen extends StatelessWidget {
  const ScanConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanConfirmationBloc()..add(const Initial()),
      child: BlocListener<ScanConfirmationBloc, ScanConfirmationState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<ScanConfirmationBloc>(context).add(const ClearPageCommand());

          if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar.failure(pageCommand.message));
          } else if (pageCommand is ShowMessage) {
            eventBus.fire(ShowSnackBar.success(pageCommand.message));
          } else if (pageCommand is ShowTransactionSuccess) {
            const ScanTransactionSuccessDialog().show(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("Transaction Actions")),
          bottomNavigationBar: BlocBuilder<ScanConfirmationBloc, ScanConfirmationState>(
            buildWhen: (previous, current) => previous.actionButtonLoading != current.actionButtonLoading,
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FlatButtonLong(
                    title: state.transactionSendError == null ? 'Confirm and Send' : 'Done',
                    onPressed: () {
                      BlocProvider.of<ScanConfirmationBloc>(context).add(const OnSendTapped());
                    },
                    isLoading: state.actionButtonLoading,
                  ),
                ),
              );
            },
          ),
          body: BlocBuilder<ScanConfirmationBloc, ScanConfirmationState>(
            builder: (context, state) {
              return HashedBodyWidget(
                pageState: state.pageState,
                success: (context) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (state.transactionSendError != null) ...[_ErrorWidget(state.transactionSendError!)],
                      ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return mockData[index];
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 16);
                        },
                        itemCount: mockData.length,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String transactionSendError;

  // ignore: use_super_parameters
  const _ErrorWidget(
    this.transactionSendError, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          const CustomPaint(size: Size(60, 60), painter: RedExclamationCircle()),
          Text(transactionSendError),
        ],
      ),
    );
  }
}
