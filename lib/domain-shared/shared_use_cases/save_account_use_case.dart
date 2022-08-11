import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/auth_data_model.dart';
import 'package:hashed/datasource/local/web_view_cache_service.dart';
import 'package:hashed/domain-shared/shared_use_cases/account_use_case.dart';

class SaveAccountUseCase extends AccountUseCase {
  Future<void> run({required String accountName, required AuthDataModel authData}) async {
    final String oldAccountName = accountService.currentAccount.address;
    await accountService.createAccount(name: accountName, privateKey: authData.wordsString);
    await const WebViewCacheService().clearCache();
    await updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
