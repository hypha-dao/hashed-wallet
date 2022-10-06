import 'package:async/async.dart';
import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/api/http_repo/http_repository.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';

class GuardiansRepository with HttpRepository {
  /// Step 1 setting up guardians - set the guardians for an account
  ///
  /// guardians - list of public keys that are the guardians - between 2 and N accounts
  ///
  Future<Result> createRecovery(GuardiansConfigModel guardians) async {
    print('[eos] create recovery: $guardians');

    return polkadotRepository.recoveryRepository.createRecoveryConfig(accountService.currentAccount.address, guardians);
  }

  /// Claim recovered account for user - this switches the new public key live at the end of the
  /// recovery process.
  ///
  /// This can be called without logging in - the assumption is that the user lost their key,
  /// asked for recovery, was recovered, waited 24 hours for the time lock - and then calls this
  /// method to regain access.
  ///
  Future<Result> claimRecoveredAccount(String userAccount) async {
    throw UnimplementedError();
  }

  /// Cancel guardians.
  ///
  /// This cancels any recovery currently in process, and removes all guardians
  ///
  Future<Result> removeGuardians() async {
    return polkadotRepository.recoveryRepository
        .removeRecoveryConfiguration(address: accountService.currentAccount.address);
  }

  /// Recover an account via the key guardian system
  ///
  /// userAcount - the account to recovery, iE current user is a guardian for userAccount
  /// publicKey - the new public key on the account once the recovery is complete
  ///
  /// When 2 or 3 of the guardians call this function, the account can be recovered with claim
  ///
  Future<Result> recoverAccount({required String lostAccount, required String rescuerAccount}) async {
    // This will need to be removed - works different on Polkadot / Subsrate
    return polkadotRepository.recoveryRepository.vouch(
        address: accountService.currentAccount.address, lostAccount: lostAccount, recovererAccount: rescuerAccount);
  }

  Future<Result<List<ActiveRecoveryModel>>> getAccountRecovery(String lostAccountName) async {
    print('[http] get account recovery for lost account: $lostAccountName');

    return polkadotRepository.recoveryRepository.getActiveRecoveries(lostAccountName);
  }

  Future<Result<GuardiansConfigModel>> getAccountGuardians(String accountName) async {
    return polkadotRepository.recoveryRepository.getRecoveryConfig(accountName);
  }

  Future<Result<dynamic>> generateRecoveryRequest(GuardianRecoveryRequestData data) async {
    print('[ESR] generateRecoveryRequest');

    try {
      final link = CreateFirebaseDynamicLinkUseCase().createDynamicLink(data);
      return Result.value(link);
    } catch (error) {
      print("Error creating recovery link $error");
      return Result.error(error);
    }
  }
}
