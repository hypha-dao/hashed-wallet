import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardians_data.dart';

class GetGuardiansDataUseCase {
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  GuardiansData getGuardiansData() {
    return _repository.getGuardiansDataForUser(settingsStorage.accountName);
  }
}
