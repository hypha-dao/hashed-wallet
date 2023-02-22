import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/scanner/scanner_view.dart';
import 'package:hashed/datasource/local/models/substrate_extrinsic_model.dart';
import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/local/models/tx_sender_data.dart';
import 'package:hashed/datasource/local/signing_request_repository.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/transfer/send/send_scanner/interactor/viewmodels/send_scanner_bloc.dart';

class SendScannerScreen extends StatefulWidget {
  const SendScannerScreen({super.key});

  @override
  _SendScannerScreenState createState() => _SendScannerScreenState();
}

class _SendScannerScreenState extends State<SendScannerScreen> {
  late ScannerView _scannerWidget;
  late SendScannerBloc _sendScannerBloc;

  @override
  void initState() {
    super.initState();
    _sendScannerBloc = SendScannerBloc();
    _scannerWidget = ScannerView(onCodeScanned: (scanResult) async {
      _sendScannerBloc.add(ExecuteScanResult(scanResult));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: BlocProvider(
        create: (_) => _sendScannerBloc,
        child: BlocListener<SendScannerBloc, SendScannerState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) async {
            final pageCommand = state.pageCommand;
            BlocProvider.of<SendScannerBloc>(context).add(const ClearSendScannerPageCommand());
            if (pageCommand is NavigateToScanConfirmation) {
              await NavigationService.of(context).navigateTo(pageCommand.route, arguments: pageCommand.arguments);
              // 'reload' this view - but only after the new page is up
              _sendScannerBloc.add(const InitializeScanner());
            }
            if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).navigateTo(pageCommand.route);
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text("Scan QR Code to Send", style: Theme.of(context).textTheme.button),
              const SizedBox(height: 82),
              _scannerWidget,
              BlocBuilder<SendScannerBloc, SendScannerState>(
                builder: (context, state) {
                  switch (state.pageState) {
                    case PageState.initial:
                      _scannerWidget.scan();
                      return const SizedBox.shrink();
                    case PageState.loading:
                      return const SizedBox.shrink();
                    case PageState.failure:
                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.errorMessage!,
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.orangeAccent),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),

              // Test code
              // const SizedBox(height: 32),
              // FlatButtonLong(
              //     title: "Test",
              //     onPressed: () {
              //       _sendScannerBloc.add(ExecuteScanResult(SSRMockDataGenerator().generateMockSSR()));
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}

class SSRMockDataGenerator {
  String generateMockSSR() {
    final repo = SigningRequestRepository();
    final txInfo = const SubstrateExtrinsicModel(module: 'balances', call: 'transfer', sender: TxSenderData.signer);
    final hasher5 = "5Dnk6vQhAVDY9ysZr8jrqWJENDWYHaF3zorFA4dr9Mtbei77";
    final transactionModel = SubstrateTransactionModel(extrinsic: txInfo, parameters: [hasher5, 2000000000000000]);
    final SubstrateSigningRequestModel model = SubstrateSigningRequestModel(
      chainId: "hashed", // select chain
      // chainId: "polkadot",
      transactions: [transactionModel],
    );
    final ssrUrlResult = repo.toUrl(model);
    final ssrUrl = ssrUrlResult.asValue!.value;
    return ssrUrl;
  }
}
