import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';

class FetchRecoverAccountOverviewData {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result<RecoveryOverviewData>> run(String accountName, {String? lostAccount, bool mock = false}) async {
    print("fetch overvew with $accountName and optional lost account: $lostAccount");

    if (mock) {
      print("mock data");
      return Result.value(RecoveryOverviewData.mock);
    }

    Result<ActiveRecoveryModel?>? activeResult;

    if (lostAccount != null) {
      activeResult =
          await polkadotRepository.recoveryRepository.getActiveRecoveriesForLostaccount(accountName, lostAccount);
      if (activeResult.isError) {
        print("Error retrieving active recoveries for $accountName");
        return Result.error(activeResult.asError!.error);
      }
    }

    return Result.value(RecoveryOverviewData(
      activeRecoveryLostAccount: settingsStorage.activeRecoveryAccount,
      activeRecovery: activeResult?.asValue!.value,
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
  );
}
