// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class RecoverUseCase {
  Future<Result<dynamic>> run({required String rescuer, required String lostAccount, bool mock = false}) async {
    if (mock) {
      return Result.value(true);
    }

    final res = await polkadotRepository.recoveryRepository.claimRecovery(rescuer: rescuer, lostAccount: lostAccount);
    return res;
  }
}
