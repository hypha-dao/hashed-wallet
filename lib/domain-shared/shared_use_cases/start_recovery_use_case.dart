import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/domain-shared/shared_use_cases/account_use_case.dart';

class StartRecoveryUseCase extends AccountUseCase {
  void run({required String accountName, required String recoveryLink}) {
    final String oldAccountName = accountService.currentAccount.address;
    settingsStorage.startRecoveryProcess(accountName: accountName, recoveryLink: recoveryLink);
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
