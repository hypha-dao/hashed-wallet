import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';

class FetchRecoverAccountDetailsData {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result<RecoveryResultData>> run(String accountName) async {
    final configResult = await _guardiansRepository.getAccountGuardians(accountName);
    final activeResult = await _guardiansRepository.getAccountRecovery(accountName);

    if (configResult.isError) {
      print("error: No recovery config found for $accountName");
      return Result.error(configResult.asError!.error);
    }

    if (activeResult.isError) {
      print("Error retrieving active recoveries for $accountName");
      return Result.error(activeResult.asError!.error);
    }

    final recoveryConfig = configResult.asValue!.value;
    final activeRecoveries = activeResult.asValue!.value;

    if (activeRecoveries.isEmpty) {
      return Result.error("No active recoveries for $accountName");
    }

    final activeRecovery = activeRecoveries.first;

    final link = await CreateFirebaseDynamicLinkUseCase()
        .createDynamicLink(GuardianRecoveryRequestData.fromRecovery(activeRecovery));

    if (link.isError) {
      print(
          "Unable to create recovery link for $accountName [rescuer ${activeRecovery.rescuer}] - error ${link.asError!.error}");
      return Result.error(link.asError!.error);
    }

    return Result.value(RecoveryResultData(
      linkToActivateGuardians: link.asValue!.value,
      configuration: recoveryConfig,
      activeRecovery: activeRecovery,
    ));
  }
}

class RecoveryResultData {
  final Uri linkToActivateGuardians;
  final GuardiansConfigModel configuration;
  final ActiveRecoveryModel activeRecovery;

  RecoveryResultData({
    required this.linkToActivateGuardians,
    required this.configuration,
    required this.activeRecovery,
  });
}
