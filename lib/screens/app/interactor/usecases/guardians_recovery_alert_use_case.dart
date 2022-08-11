import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/firebase/firebase_user_repository.dart';

class RecoveryAlertUseCase {
  Stream<bool> get shouldShowCancelGuardianAlertMessage {
    return FirebaseUserRepository()
        .getUserData(accountService.currentAccount.address)
        .asyncMap((event) => event.guardianRecoveryStarted != null);
  }
}
