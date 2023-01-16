import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/amount_entry/amount_entry_widget.dart';
import 'package:hashed/components/balance_row.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/components/text_form_field_light.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/transfer/receive/receive_enter_data/interactor/viewmodels/page_commands.dart';
import 'package:hashed/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_bloc.dart';
import 'package:hashed/utils/build_context_extension.dart';

class ReceiveEnterDataScreen extends StatefulWidget {
  const ReceiveEnterDataScreen({super.key});

  @override
  State<ReceiveEnterDataScreen> createState() => _ReceiveEnterDataScreenState();
}

class _ReceiveEnterDataScreenState extends State<ReceiveEnterDataScreen> {
  late final ReceiveEnterDataBloc _receiveEnterDataBloc;
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    _receiveEnterDataBloc = ReceiveEnterDataBloc(BlocProvider.of<RatesBloc>(context).state)
      ..add(const LoadUserBalance());
    _memoController.addListener(() => _receiveEnterDataBloc.add(OnMemoChanged(_memoController.text)));
    _memoController.text = _receiveEnterDataBloc.state.generateRandomString(6);
    super.initState();
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _receiveEnterDataBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.transferReceiveTitle)),
        body: BlocConsumer<ReceiveEnterDataBloc, ReceiveEnterDataState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;
            if (pageCommand is NavigateToReceiveDetails) {
              NavigationService.of(context).navigateTo(Routes.receiveQR, arguments: pageCommand.details, replace: true);
            } else if (state.pageCommand is ShowTransactionFail) {
              BlocProvider.of<ReceiveEnterDataBloc>(context).add(const ClearReceiveEnterDataState());
              eventBus.fire(ShowSnackBar(context.loc.transferReceiveTransactionFail));
            }
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.success:
                return SafeArea(
                  minimum: const EdgeInsets.all(horizontalEdgePadding),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            AmountEntryWidget(
                              tokenDataModel: TokenDataModel(0, token: settingsStorage.selectedToken),
                              onValueChange: (value) => _receiveEnterDataBloc.add(OnAmountChange(value)),
                              autoFocus: state.isAutoFocus,
                            ),
                            const SizedBox(height: 36),
                            Column(
                              children: [
                                const SizedBox(height: 16),
                                BalanceRow(
                                  label: context.loc.transferReceiveAvailableBalance,
                                  fiatAmount: state.availableBalanceFiat,
                                  tokenAmount: state.availableBalanceToken,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButtonLong(
                          title: context.loc.transferReceiveNextButtonTitle,
                          enabled: state.isNextButtonEnabled,
                          onPressed: () => _receiveEnterDataBloc.add(const OnNextButtonTapped()),
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
    );
  }
}
