import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/firebase/firebase_database_guardians_repository.dart';

class GuardiansNotificationUseCase {
  Stream<bool> get hasGuardianNotificationPending {
    return Stream.value(
        FirebaseDatabaseGuardiansRepository().hasGuardianNotificationPending(accountService.currentAccount.address));
  }
}
