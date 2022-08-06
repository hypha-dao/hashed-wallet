import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';

class InitGuardiansUseCase {
  // ignore: unused_field
  final FirebaseDatabaseGuardiansRepository _firebaseRepository = FirebaseDatabaseGuardiansRepository();

  void initGuardians(Iterable<Account> myGuardians) {}
}
