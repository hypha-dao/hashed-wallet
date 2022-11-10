import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/scanner/scanner_view.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/transfer/send/send_scanner/interactor/viewmodels/send_scanner_bloc.dart';
import 'package:hashed/utils/build_context_extension.dart';

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
      appBar: AppBar(title: Text(context.loc.transferSendScanQRCode)),
      body: BlocProvider(
        create: (_) => _sendScannerBloc,
        child: BlocListener<SendScannerBloc, SendScannerState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;
            BlocProvider.of<SendScannerBloc>(context).add(const ClearSendScannerPageCommand());
            if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).navigateTo(pageCommand.route);
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(context.loc.transferSendScanQRCodePrompt, style: Theme.of(context).textTheme.button),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
