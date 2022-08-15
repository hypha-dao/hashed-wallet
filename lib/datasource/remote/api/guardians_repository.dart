import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/http_repo/http_repository.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';

class GuardiansRepository with HttpRepository {
  /// Step 1 setting up guardians - set the guardians for an account
  ///
  /// guardians - list of public keys that are the guardians - between 2 and N accounts
  ///
  Future<Result> createRecovery(GuardiansConfigModel guardians) async {
    print('[eos] create recovery: $guardians');

    return polkadotRepository.createRecovery(guardians);
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
    return polkadotRepository.removeRecovery();
  }

  /// Recover an account via the key guardian system
  ///
  /// userAcount - the account to recovery, iE current user is a guardian for userAccount
  /// publicKey - the new public key on the account once the recovery is complete
  ///
  /// When 2 or 3 of the guardians call this function, the account can be recovered with claim
  ///
  Future<Result> recoverAccount(String userAccount, String publicKey) async {
    // This will need to be removed - works different on Polkadot / Subsrate
    throw UnimplementedError();
  }

  Future<Result<dynamic>> getAccountRecovery(String accountName) async {
    print('[http] get account recovery $accountName');

    return polkadotRepository.getActiveRecovery();
  }

  Future<Result<GuardiansConfigModel>> getAccountGuardians(String accountName) async {
    return polkadotRepository.getRecoveryConfig(accountName);
  }

  Future<Result<dynamic>> generateRecoveryRequest(String accountName, String publicKey) async {
    print('[ESR] generateRecoveryRequest: $accountName publicKey: ($publicKey)');

    // Need to implement this
    throw UnimplementedError();
  }
}
