import 'package:async/async.dart';
import 'package:hashed/datasource/local/qr_code_service.dart';

class ProcessScanResultUseCase {
  QrCodeService qrCodeService = QrCodeService();

  Future<Result> run(String scanResult) async {
    return qrCodeService.processQrCode(scanResult, 'settingsStorage.accountName');
  }
}
