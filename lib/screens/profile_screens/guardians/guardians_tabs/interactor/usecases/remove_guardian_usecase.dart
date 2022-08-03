// ignore_for_file: unused_field

import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';

class RemoveGuardianUseCase {
  final FirebaseDatabaseGuardiansRepository _firebaseRepository = FirebaseDatabaseGuardiansRepository();
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  bool removeGuardian(Account guardian) {
    /// Make call to remove guardian
    return true;
  }
}
