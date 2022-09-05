// ignore_for_file: unused_field

import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class RemoveGuardianUseCase {
  Future<Result> removeGuardian(Account guardian) {
    return polkadotRepository.recoveryRepository.removeRecovery(address: accountService.currentAccount.address);
  }
}
