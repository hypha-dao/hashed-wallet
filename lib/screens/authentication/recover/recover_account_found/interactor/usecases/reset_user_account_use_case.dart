import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/datasource/remote/firebase/firebase_database_guardians_repository.dart';

class ResetUserAccountUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final FirebaseDatabaseGuardiansRepository _firebaseDatabaseGuardiansRepository =
      FirebaseDatabaseGuardiansRepository();

  Future<Result> run(String userAccount) async {
    final result = await _guardiansRepository.claimRecoveredAccount(userAccount);

    if (result.isValue) {
      await _firebaseDatabaseGuardiansRepository.removeGuardianRecoveryStarted(userAccount);
    }

    return result;
  }
}
