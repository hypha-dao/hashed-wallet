import 'package:async/async.dart';
import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/datasource/local/signing_request_repository.dart';

class QrCodeService {
  Result<SubstrateSigningRequestModel> processQrCode(String scanResult) {
    final splitUri = scanResult.split(':');
    final scheme = splitUri[0];
    if (scheme != 'ssr') {
      print("processQrCode : Invalid QR code");
      return Result.error('Invalid QR Code');
    }

    final SubstrateSigningRequestModel? ssr = SigningRequestRepository().parseUrl(scanResult);
    if (ssr != null) {
      return Result.value(ssr);
    } else {
      return Result.error("Error processing QR code");
    }
  }
}
