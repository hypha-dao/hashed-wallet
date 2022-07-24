import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';

class GetGuardiansUseCase {
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  List<GuardianModel> getGuardians() {
    return _repository.getGuardiansForUser(settingsStorage.accountName);
  }
}
