import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/balance_row.dart';
import 'package:hashed/components/divider_jungle.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/qr_code_generator_widget.dart';
import 'package:hashed/components/share_link_row.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details.dart';
import 'package:hashed/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details_bloc.dart';
import 'package:hashed/utils/build_context_extension.dart';

class ReceiveDetailQrCodeScreen extends StatelessWidget {
  final ReceiveDetails details;

  const ReceiveDetailQrCodeScreen(this.details, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => ReceiveDetailsBloc(details, BlocProvider.of<RatesBloc>(context).state),
      child: BlocConsumer<ReceiveDetailsBloc, ReceiveDetailsState>(
        listenWhen: (_, current) => current.receivePaidSuccessArgs != null,
        listener: (context, state) {
          Navigator.of(context).pop(); // pop this screen
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Scan QR Code')),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: size.height,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          ColoredBox(
                            color: Theme.of(context).colorScheme.onBackground,
                            child: QrCodeGeneratorWidget(data: state.details.invoiceLink, size: size.width * 0.8),
                          ),
                          const SizedBox(height: 20),
                          ShareLinkRow(
                            label: "Share Link",
                            link: state.details.invoiceLinkUri == null
                                ? state.details.invoiceLink
                                : state.details.invoiceLinkUri.toString(),
                          ),
                          const SizedBox(height: 4),
                          const DividerJungle(height: 6),
                          const SizedBox(height: 16),
                          BalanceRow(
                            label: context.loc.transferReceiveBalanceTotal,
                            fiatAmount: state.details.fiatAmount,
                            tokenAmount: state.details.tokenAmount,
                          ),
                          const SizedBox(height: 4),
                          const DividerJungle(thickness: 2.0, height: 10),
                          const SizedBox(height: 4),
                          const SizedBox(height: 40),
                          Text("Waiting for payment", style: Theme.of(context).textTheme.titleLarge),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(60.0, 40, 60.0, 0),
                            child: FlatButtonLong(
                              enabled: !state.isCheckButtonLoading,
                              isLoading: state.isCheckButtonLoading,
                              title: "Done",
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
