import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/cache_repository.dart';
import 'package:hashed/datasource/local/models/auth_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/local/web_view_cache_service.dart';
import 'package:hashed/domain-shared/shared_use_cases/account_use_case.dart';

class SwitchAccountUseCase extends AccountUseCase {
  Future<void> run(String accountName, AuthDataModel authData) async {
    final String oldAccountName = accountService.currentAccount.address;
    await settingsStorage.switchAccount(accountName, authData);
    await const CacheRepository().clear();
    await const WebViewCacheService().clearCache();
    //ignore: unawaited_futures
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
