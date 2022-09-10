import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/domain-shared/shared_use_cases/start_recovery_use_case.dart';
import 'package:hashed/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:hashed/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_bloc.dart';
import 'package:hashed/screens/authentication/recover/recover_account_found/recover_account_found_errors.dart';

class FetchRecoverRecoveryStateMapper extends StateMapper {
  RecoverAccountFoundState mapResultToState(RecoverAccountFoundState currentState, RecoverGuardianInitialDTO result) {
    final Result linkResult = result.link;
    final Result activeRecoveries = result.activeRecoveries;
    final Result guardianConfig = result.guardianConfig;

    final Uri? link = linkResult.asValue?.value;
    final List<ActiveRecoveryModel>? userRecoversModelData = activeRecoveries.asValue?.value;
    ActiveRecoveryModel? activeRecovery;
    if (userRecoversModelData != null && userRecoversModelData.isNotEmpty) {
      activeRecovery = userRecoversModelData.firstWhere((e) => e.rescuer == accountService.currentAccount.address,
          orElse: () => userRecoversModelData.first);
    }
    final GuardiansConfigModel? userGuardiansModel = guardianConfig.asValue?.value;

    final hasGuardians = guardianConfig.asValue?.value != null;

    // Check that we have all data needed from the server and it is valid.
    // We need data from multiple services and any of them can fail.
    // This is the minimum required data to proceed
    if (hasGuardians && link != null && activeRecovery != null && userGuardiansModel != null) {
      final List<Account> guardians = userGuardiansModel.guardianAddresses.map((e) => Account(address: e)).toList();
      final confirmedGuardianSignatures = activeRecovery.friends.length;

      // check how long we have to wait before we can claim (24h delay is standard)
      final timeLockExpiryBlocks = activeRecovery.created + userGuardiansModel.delayPeriod;

      RecoveryStatus recoveryStatus;
      // for 3 signers, we need 2/3 signatures. For 4 or 5 signers, we need 3+ signatures.
      if (confirmedGuardianSignatures > userGuardiansModel.threshold) {
        if (timeLockExpiryBlocks <= DateTime.now().millisecondsSinceEpoch / 1000 / 6) {
          recoveryStatus = RecoveryStatus.readyToClaimAccount;
        } else {
          recoveryStatus = RecoveryStatus.waitingFor24HourCoolPeriod;
        }
      } else {
        recoveryStatus = RecoveryStatus.waitingForGuardiansToSign;
      }

      /// Save Recovery values
      StartRecoveryUseCase().run(
        accountName: currentState.userAccount,
        recoveryLink: link.toString(),
      );

      return currentState.copyWith(
        pageState: PageState.success,
        linkToActivateGuardians: link,
        userGuardiansData: guardians,
        confirmedGuardianSignatures: confirmedGuardianSignatures,
        recoveryStatus: recoveryStatus,
        alreadySignedGuardians: activeRecovery.friends,
        timeLockExpirySeconds: timeLockExpiryBlocks,
      );
    } else if (!hasGuardians) {
      return currentState.copyWith(
        pageState: PageState.failure,
        error: RecoverAccountFoundError.noGuardians,
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.failure,
        error: RecoverAccountFoundError.unknown,
      );
    }
  }
}
