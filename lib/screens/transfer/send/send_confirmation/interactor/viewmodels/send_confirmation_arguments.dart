import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';

class SendConfirmationArguments {
  final SendTransaction transaction;
  final String? callback;

  const SendConfirmationArguments({required this.transaction, this.callback});

  // factory SendConfirmationArguments.from(ScanQrCodeResultData data) =>
  //     SendConfirmationArguments(transaction: data.transaction, callback: data.esr.callback);
}
