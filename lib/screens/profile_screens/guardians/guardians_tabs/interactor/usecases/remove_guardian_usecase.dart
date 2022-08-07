// ignore_for_file: unused_field

import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:seeds/utils/result_extension.dart';

class RemoveGuardianUseCase {
  Future<Result> removeGuardian(Account guardian) {
    return polkadotRepository.removeGuardians();
  }
}
