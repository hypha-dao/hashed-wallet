import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_type.dart';

class AddGuardianUseCase {
  bool addGuardian(String key, String? nickname) {
    /// Make call to add guardian
    return true;
  }
}
