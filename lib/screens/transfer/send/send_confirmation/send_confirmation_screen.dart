import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/error_dialog.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/components/send_loading_indicator.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
// ignore: unused_import
import 'package:hashed/screens/transfer/send/send_confirmation/components/generic_transaction_success_dialog.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/components/transaction_action_card.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:hashed/utils/build_context_extension.dart';

class SendConfirmationScreen extends StatelessWidget {
  const SendConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments! as SendConfirmationArguments;
    return BlocProvider(
      create: (_) => SendConfirmationBloc(arguments)..add(const OnInitValidations()),
      child: BlocBuilder<SendConfirmationBloc, SendConfirmationState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              // Clear deeplink on navigate back (i.e. cancel confirm link)
              BlocProvider.of<DeeplinkBloc>(context).add(const ClearDeepLink());
              Navigator.of(context).pop(state.transactionResult);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(title: const Text('Back')),
              body: BlocConsumer<SendConfirmationBloc, SendConfirmationState>(
                listenWhen: (_, current) => current.pageCommand != null,
                listener: (context, state) {
                  final pageCommand = state.pageCommand;
                  // Clear deeplink despite the submit result
                  BlocProvider.of<DeeplinkBloc>(context).add(const ClearDeepLink());
                  if (pageCommand is ShowTransferSuccess) {
                    Navigator.of(context).pop(state.transactionResult);
                    SendTransactionSuccessDialog.fromPageCommand(pageCommand).show(context);
                  } else if (pageCommand is ShowTransactionSuccess) {
                    Navigator.of(context).pop(state.transactionResult);
                    throw UnimplementedError("not handling generic transactions yet");
                    //GenericTransactionSuccessDialog(pageCommand.transactionModel).show(context);
                  } else if (pageCommand is ShowFailedTransactionReason) {
                    ErrorDialog(
                      title: pageCommand.title,
                      details: pageCommand.details,
                      onRightButtonPressed: () {
                        final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                        BlocProvider.of<SendConfirmationBloc>(context).add(OnSendTransactionButtonPressed(rates));
                      },
                    ).show(context);
                  } else if (pageCommand is ShowInvalidTransactionReason) {
                    eventBus.fire(ShowSnackBar(pageCommand.reason));
                  }
                },
                builder: (context, state) {
                  switch (state.pageState) {
                    case PageState.loading:
                      return state.isTransfer ? const SendLoadingIndicator() : const FullPageLoadingIndicator();
                    case PageState.failure:
                      return FullPageErrorIndicator(errorMessage: state.errorMessage);
                    case PageState.success:
                      return SafeArea(
                        minimum: const EdgeInsets.all(horizontalEdgePadding),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.only(bottom: 24),
                                shrinkWrap: true,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 32.0, top: 20),
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: const BoxDecoration(shape: BoxShape.circle),
                                      child: SvgPicture.asset("assets/images/seeds_logo.svg"),
                                    ),
                                  ),
                                  for (final i in [state.transaction]) TransactionActionCard(i)
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: FlatButtonLong(
                                enabled: state.invalidTransaction == InvalidTransaction.none,
                                title: context.loc.transferConfirmationButton,
                                onPressed: () {
                                  final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                                  BlocProvider.of<SendConfirmationBloc>(context)
                                      .add(OnSendTransactionButtonPressed(rates));
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
