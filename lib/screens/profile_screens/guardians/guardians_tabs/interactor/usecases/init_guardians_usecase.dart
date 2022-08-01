import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';

class InitGuardiansUseCase {
  // ignore: unused_field
  final FirebaseDatabaseGuardiansRepository _firebaseRepository = FirebaseDatabaseGuardiansRepository();

  void initGuardians(Iterable<GuardianModel> myGuardians) {}
}
