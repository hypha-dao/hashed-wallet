import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/cache_repository.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/local/web_view_cache_service.dart';
import 'package:hashed/domain-shared/shared_use_cases/account_use_case.dart';

class RemoveAccountUseCase extends AccountUseCase {
  Future<void> run() async {
    final String oldAccountName = accountService.currentAccount.address;
    await settingsStorage.removeAccount();
    await const CacheRepository().clear();
    await const WebViewCacheService().clearCache();
    //ignore: unawaited_futures
    updateFirebaseToken(oldAccount: oldAccountName);
  }
}
