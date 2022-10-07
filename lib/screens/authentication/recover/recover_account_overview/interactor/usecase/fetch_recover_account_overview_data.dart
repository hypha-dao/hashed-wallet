import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountOverviewUsecase {
  Future<Result<RecoveryOverviewData>> run(String accountAddress, {String? lostAccount, bool mock = false}) async {
    print("fetch overvew with $accountAddress and optional lost account: $lostAccount");

    if (mock) {
      print("mock data");
      return Result.value(RecoveryOverviewData.mock);
    }

    Result<ActiveRecoveryModel>? activeResult;

    if (lostAccount != null) {
      activeResult = await polkadotRepository.recoveryRepository
          .getActiveRecoveriesForLostaccount(rescuer: accountAddress, lostAccount: lostAccount);
      if (activeResult.isError) {
        print("Error retrieving active recoveries for $accountAddress");
        return Result.error(activeResult.asError!.error);
      }
    }

    final proxies = await polkadotRepository.recoveryRepository.getProxies(accountAddress);
    if (proxies.isError) {
      print("Error retrieving proxies for $accountAddress");
      return Result.error(proxies.asError!.error);
    }

    return Result.value(RecoveryOverviewData(
      activeRecoveryLostAccount: settingsStorage.activeRecoveryAccount,
      activeRecovery: activeResult?.asValue!.value,
      proxyAccounts: proxies.asValue!.value,
    ));
  }
}

class RecoveryOverviewData {
  final String? activeRecoveryLostAccount;
  final ActiveRecoveryModel? activeRecovery;
  final List<String> proxyAccounts;

  RecoveryOverviewData({
    required this.activeRecoveryLostAccount,
    this.activeRecovery,
    this.proxyAccounts = const [],
  });

  static RecoveryOverviewData mock = RecoveryOverviewData(
    activeRecoveryLostAccount: ActiveRecoveryModel.mock.lostAccount,
    activeRecovery: ActiveRecoveryModel.mock,
    proxyAccounts: ["5j_mock01", "5j_mock02"],
  );
}
