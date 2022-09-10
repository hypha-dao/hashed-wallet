// ignore_for_file: prefer_final_locals, unused_local_variable

import 'package:async/async.dart';
import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/datasource/local/models/account.dart';

import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';

class FetchRecoverGuardianInitialDataUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final CreateFirebaseDynamicLinkUseCase _createFirebaseDynamicLinkUseCase = CreateFirebaseDynamicLinkUseCase();

  Future<RecoverGuardianInitialDTO> run({required String lostAccount, required String rescuer}) async {
    print("FetchRecoverGuardianInitialDataUseCase $lostAccount");

    /// returns an empty list in case there are no active recoveries
    final activeRecoveries = await _guardiansRepository.getAccountRecovery(lostAccount);

    /// returns null if there are no guardians set up (error case)
    final accountGuardians = await _guardiansRepository.getAccountGuardians(lostAccount);

    List<Account> membersData = [];
    if (accountGuardians.isValue) {
      membersData = accountGuardians.asValue!.value.guardians.toList();
    }
    final actives = activeRecoveries.asValue?.value;

    final data = GuardianRecoveryRequestData(lostAccount: lostAccount, rescuer: rescuer);

    if (actives != null && actives.isNotEmpty) {
      return _continueWithRecovery(
        recoveryRequestData: data,
        activeRecoveries: activeRecoveries,
        guardianConfig: accountGuardians,
      );
    } else {
      return _startNewRecovery(
        recoveryRequestData: data,
        activeRecoveries: activeRecoveries,
        guardianConfig: accountGuardians,
      );
    }
  }

  Future<Result<dynamic>> generateFirebaseDynamicLink(GuardianRecoveryRequestData data) async {
    final guardianLink = await _createFirebaseDynamicLinkUseCase.createDynamicLink(data);
    return guardianLink;
  }

  /// USER already started a recovery. Fetch the values from storage
  Future<RecoverGuardianInitialDTO> _continueWithRecovery({
    required GuardianRecoveryRequestData recoveryRequestData,
    required Result<List<ActiveRecoveryModel>> activeRecoveries,
    required Result<GuardiansConfigModel> guardianConfig,
    // required List<Account> membersData,
  }) async {
    return RecoverGuardianInitialDTO(
      link: ValueResult(Uri.parse(settingsStorage.recoveryLink)),
      // membersData: membersData,
      activeRecoveries: activeRecoveries,
      guardianConfig: guardianConfig,
    );
  }

  /// USER does not have an active recovery. Create new recovery values.
  Future<RecoverGuardianInitialDTO> _startNewRecovery({
    required GuardianRecoveryRequestData recoveryRequestData,
    required Result<List<ActiveRecoveryModel>> activeRecoveries,
    required Result<GuardiansConfigModel> guardianConfig,
    // required List<Account> membersData,
  }) async {
    Result link = await _guardiansRepository.generateRecoveryRequest(recoveryRequestData);

    return RecoverGuardianInitialDTO(
      link: link,
      // membersData: membersData,
      activeRecoveries: activeRecoveries,
      guardianConfig: guardianConfig,
    );
  }
}

class RecoverGuardianInitialDTO {
  final Result link;
  // final List<Account> membersData;
  final Result<List<ActiveRecoveryModel>> activeRecoveries;
  final Result<GuardiansConfigModel> guardianConfig;

  RecoverGuardianInitialDTO({
    required this.link,
    // required this.membersData,
    required this.activeRecoveries,
    required this.guardianConfig,
  });
}
