import 'package:async/async.dart';
import 'package:hashed/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:hashed/datasource/local/qr_code_service.dart';

class ProcessScanResultUseCase {
  QrCodeService qrCodeService = QrCodeService();

  Future<Result<ScanQrCodeResultData>> run(String scanResult) async {
    return qrCodeService.processQrCode(scanResult);
  }
}
