import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/alert_input_value.dart';
import 'package:hashed/components/amount_entry/amount_entry_widget.dart';
import 'package:hashed/components/balance_row.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/components/send_loading_indicator.dart';
import 'package:hashed/components/text_form_field_light.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/components/send_confirmation_dialog.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/viewmodels/show_send_confirm_dialog_data.dart';
import 'package:hashed/utils/build_context_extension.dart';
import 'package:hashed/utils/short_string.dart';

class SendEnterDataScreen extends StatelessWidget {
  const SendEnterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Account memberModel = ModalRoute.of(context)!.settings.arguments! as Account;
    final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
    return BlocProvider(
      create: (_) => SendEnterDataBloc(memberModel, rates)..add(InitSendDataArguments()),
      child: BlocListener<SendEnterDataBloc, SendEnterDataState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final PageCommand? command = state.pageCommand;

          BlocProvider.of<SendEnterDataBloc>(context).add(const ClearSendEnterDataPageCommand());

          if (command is ShowSendConfirmDialog) {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button
              builder: (_) => SendConfirmationDialog(
                onSendButtonPressed: () {
                  BlocProvider.of<SendEnterDataBloc>(context).add(const OnSendButtonTapped());
                },
                tokenAmount: command.tokenAmount,
                fiatAmount: command.fiatAmount,
                toAccount: command.toAccount,
                toImage: command.toImage,
                toName: command.toName,
                memo: command.memo,
              ),
            );
          } else if (command is ShowTransferSuccess) {
            Navigator.of(context).pop(); // pop send
            Navigator.of(context).pop(); // pop scanner
            SendTransactionSuccessDialog.fromPageCommand(command).show(context);
          } else if (command is ShowTransactionSuccess) {
            Navigator.of(context).pop(); // pop send
            Navigator.of(context).pop(); // pop scanner
            throw UnimplementedError("generic tx not implemented");
            //GenericTransactionSuccessDialog(command.transactionHash).show(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text(context.loc.transferSendTitle)),
          extendBodyBehindAppBar: true,
          body: BlocBuilder<SendEnterDataBloc, SendEnterDataState>(
            buildWhen: (_, current) => current.pageCommand == null,
            builder: (context, state) {
              switch (state.pageState) {
                case PageState.initial:
                  return const SizedBox.shrink();
                case PageState.loading:

                  /// We want to show special animation only when the user confirms send.
                  return state.showSendingAnimation
                      ? const SendLoadingIndicator()
                      : const SafeArea(child: FullPageLoadingIndicator());
                case PageState.failure:
                  return const SafeArea(child: FullPageErrorIndicator());
                case PageState.success:
                  return SafeArea(
                    minimum: const EdgeInsets.all(horizontalEdgePadding),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  context.loc.transferSendSendTo,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // ignore: unnecessary_string_interpolations
                              Text("${memberModel.address.shorter}"),
                              const SizedBox(height: 24),
                              AmountEntryWidget(
                                tokenDataModel: TokenDataModel(0, token: settingsStorage.selectedToken),
                                onValueChange: (value) {
                                  BlocProvider.of<SendEnterDataBloc>(context).add(OnAmountChange(amountChanged: value));
                                },
                                autoFocus: state.pageState == PageState.initial,
                              ),
                              const SizedBox(height: 12),
                              AlertInputValue(context.loc.transferSendNotEnoughBalanceAlert,
                                  isVisible: state.showAlert),
                              const SizedBox(height: 12),
                              Column(
                                children: [
                                  TextFormFieldLight(
                                    labelText: context.loc.transferMemoFieldLabel,
                                    hintText: context.loc.transferMemoFieldHint,
                                    maxLength: blockChainMaxChars,
                                    onChanged: (String value) {
                                      BlocProvider.of<SendEnterDataBloc>(context).add(OnMemoChange(memoChanged: value));
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  BalanceRow(
                                    label: context.loc.transferSendAvailableBalance,
                                    fiatAmount: state.availableBalanceFiat,
                                    tokenAmount: state.availableBalance,
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButtonLong(
                            title: context.loc.transferSendNextButtonTitle,
                            enabled: state.isNextButtonEnabled,
                            onPressed: () {
                              BlocProvider.of<SendEnterDataBloc>(context).add(const OnNextButtonTapped());
                            },
                          ),
                        )
                      ],
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
