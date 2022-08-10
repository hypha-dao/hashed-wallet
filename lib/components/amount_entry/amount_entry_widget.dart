import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/amount_entry/interactor/viewmodels/amount_entry_bloc.dart';
import 'package:hashed/components/amount_entry/interactor/viewmodels/page_commands.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/domain-shared/user_input_decimal_precision.dart';
import 'package:hashed/domain-shared/user_input_number_formatter.dart';

class AmountEntryWidget extends StatelessWidget {
  final TokenDataModel tokenDataModel;
  final ValueSetter<String> onValueChange;
  final bool autoFocus;

  const AmountEntryWidget({
    super.key,
    required this.tokenDataModel,
    required this.onValueChange,
    required this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
    return BlocProvider(
      create: (_) => AmountEntryBloc(rates, tokenDataModel),
      child: BlocListener<AmountEntryBloc, AmountEntryState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;

          if (pageCommand is SendTextInputDataBack) {
            onValueChange(pageCommand.textToSend);
          }

          BlocProvider.of<AmountEntryBloc>(context).add(const ClearAmountEntryPageCommand());
        },
        child: BlocBuilder<AmountEntryBloc, AmountEntryState>(
          builder: (BuildContext context, AmountEntryState state) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.headline4,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: "0.0",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        autofocus: autoFocus,
                        onChanged: (value) {
                          BlocProvider.of<AmountEntryBloc>(context).add(OnAmountChange(amountChanged: value));
                        },
                        inputFormatters: [
                          UserInputNumberFormatter(),
                          DecimalTextInputFormatter(
                            decimalRange: state.currentCurrencyInput == CurrencyInput.fiat
                                ? state.fiatAmount?.precision ?? 0
                                : state.tokenAmount.precision,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              Text(
                                state.currentCurrencyInput == CurrencyInput.token
                                    ? state.tokenAmount.symbol
                                    : state.fiatAmount?.symbol ?? "",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              const SizedBox(height: 18)
                            ],
                          ),
                          Positioned(
                            bottom: -16,
                            left: 70,
                            child: Opacity(
                              opacity: state.switchCurrencyEnabled ? 1 : 0.5,
                              child: Container(
                                height: 60,
                                width: 60,
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/images/currency_switch_button.svg',
                                    height: 60,
                                    width: 60,
                                  ),
                                  onPressed: state.switchCurrencyEnabled
                                      ? () {
                                          BlocProvider.of<AmountEntryBloc>(context)
                                              .add(const OnCurrencySwitchButtonTapped());
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  state.currentCurrencyInput == CurrencyInput.fiat
                      ? state.tokenAmount.asFormattedString()
                      : state.fiatAmount?.asFormattedString() ?? "",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
