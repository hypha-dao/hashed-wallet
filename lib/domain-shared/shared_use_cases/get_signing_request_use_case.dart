import 'package:async/async.dart';
import 'package:hashed/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/datasource/local/signing_request_repository.dart';

/// Use case to handle an incoming ESR - EOSIO Signing Request
class GetSigningRequestUseCase {
  Future<Result<ScanQrCodeResultData>> run(String uri) async {
    print("GetSigningRequestUseCase link: $uri ");
    try {
      final SubstrateSigningRequestModel ssr = SigningRequestRepository().parseUrl(uri)!;
      return Result.value(ScanQrCodeResultData(ssr));
    } catch (error) {
      return ErrorResult('ESR link is invalid: $uri');
    }
  }
}
