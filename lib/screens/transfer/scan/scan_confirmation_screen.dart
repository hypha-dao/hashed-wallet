import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/design/lib/hashed_body_widget.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/screens/transfer/scan/interactor/viewmodels/scan_confirmation_bloc.dart';

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
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("Network")),
          bottomNavigationBar: BlocBuilder<ScanConfirmationBloc, ScanConfirmationState>(
            buildWhen: (previous, current) => previous.actionButtonLoading != current.actionButtonLoading,
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FlatButtonLong(
                    title: 'Switch',
                    onPressed: () {
                      BlocProvider.of<ScanConfirmationBloc>(context).add(OnSendTapped());
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
                  child: ListView(
                    children: [],
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
