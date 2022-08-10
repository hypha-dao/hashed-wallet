import 'package:hashed/datasource/local/settings_storage.dart';

class StopRecoveryUseCase {
  Future<void> run() => settingsStorage.cancelRecoveryProcess();
}
