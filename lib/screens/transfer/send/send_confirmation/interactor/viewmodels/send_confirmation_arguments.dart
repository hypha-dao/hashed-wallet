import 'package:hashed/datasource/local/models/eos_transaction.dart';
import 'package:hashed/datasource/local/models/scan_qr_code_result_data.dart';

class SendConfirmationArguments {
  final EOSTransaction transaction;
  final String? callback;

  const SendConfirmationArguments({required this.transaction, this.callback});

  factory SendConfirmationArguments.from(ScanQrCodeResultData data) =>
      SendConfirmationArguments(transaction: data.transaction, callback: data.esr.callback);
}
