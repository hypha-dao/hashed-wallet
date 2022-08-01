import 'package:async/async.dart';
import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/local/qr_code_service.dart';

class ProcessScanResultUseCase {
  QrCodeService qrCodeService = QrCodeService();

  Future<Result> run(String scanResult) async {
    return qrCodeService.processQrCode(scanResult, accountService.currentAccount.address);
  }
}
