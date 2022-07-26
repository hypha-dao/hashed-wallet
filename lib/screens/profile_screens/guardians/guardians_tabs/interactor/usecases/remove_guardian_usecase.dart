import 'package:seeds/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';

class RemoveGuardianUseCase {
  final FirebaseDatabaseGuardiansRepository _firebaseRepository = FirebaseDatabaseGuardiansRepository();
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  bool removeGuardian(GuardianModel guardian) {
    /// Make call to remove guardian
    return true;
  }
}
