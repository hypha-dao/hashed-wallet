import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/extrinsics_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class RecoveryRepository extends ExtrinsicsRepository {
  RecoveryRepository(super.webView);

  /// Activates your guardians - Min 2 for now. (UI enforced)
  Future<Result> createRecovery(String address, GuardiansConfigModel guardians) async {
    print("create recovery: ${guardians.toJson()}");
    try {
      final res = await _createRecovery(
        address: address,
        guardians: guardians.guardianAddresses,
        threshold: guardians.threshold,
        delayPeriod: guardians.delayPeriod,
      );
      return Result.value(res);
    } catch (err) {
      return Result.error(err);
    }
  }

  Future<String> _createRecovery({
    required String address,
    required List<String> guardians,
    required int threshold,
    required int delayPeriod,
  }) async {
    final sender = TxSenderData(
      address,
    );
    final txInfo = SubstrateTransactionModel('recovery', 'createRecovery', sender);

    guardians.sort();

    try {
      final hash = await signAndSend(
        txInfo,
        [
          guardians,
          threshold,
          delayPeriod,
        ],
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendCreateRecovery ${hash.toString()}');
      return hash.toString();
    } catch (err) {
      print('sendCreateRecovery ERROR $err');
      rethrow;
    }
  }

  Future<Result<GuardiansConfigModel>> getRecoveryConfig(String address) async {
    print("get guardians for $address");

    // TODO(n13): Create a mapper for polkadot API results - similar to httpmapper
    // then add model mappers for all the different possible responses.
    // But, make it work first -
    try {
      final code = 'api.query.recovery.recoverable("$address")';
      final res = await evalJavascript(code);
      print("getRecoveryConfig res: $res");
      GuardiansConfigModel guardiansModel;
      if (res != null) {
        guardiansModel = GuardiansConfigModel.fromJson(res);
      } else {
        return Result.value(GuardiansConfigModel.empty());
      }
      return Result.value(guardiansModel);
    } catch (err) {
      print('getRecoveryConfig error: $err');
      return Result.error(err);
    }
  }

  Future<String?> _removeRecovery({required String address}) async {
    final sender = TxSenderData(
      address,
    );
    final txInfo = SubstrateTransactionModel('recovery', 'removeRecovery', sender);

    try {
      final hash = await signAndSend(
        txInfo,
        [],
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendRemoveRecovery ${hash.toString()}');
      return hash.toString();
    } catch (err) {
      print('sendRemoveRecovery ERROR $err');
      rethrow;
    }
  }

  /// Removes user's guardians. User must Start from scratch.
  /// Recovers fees.
  Future<Result> removeRecovery({required String address}) async {
    try {
      final res = await _removeRecovery(address: address);
      return Result.value(res);
    } on Exception catch (err) {
      return Result.error(err);
    }
  }

  Future<Result<dynamic>> initiateRecovery({required String address, required String lostAccount}) async {
    print("initiate recovery for $lostAccount");
    return Future.delayed(const Duration(milliseconds: 500), () => Result.value("Ok"));
  }

  /// return recoveries that are currently in process for the address in question
  /// Params: Address to be recovered
  Future<Result<List<ActiveRecoveryModel>>> getActiveRecoveries(String address) async {
    print("get active recovery for $address");

    // no results
    // return Future.delayed(const Duration(milliseconds: 500), () => Result.value([]));

    // mock result
    return Future.delayed(
        const Duration(milliseconds: 500),
        () => Result.value(
              [
                ActiveRecoveryModel(
                    lostAccount: address,
                    recoverer: "0xmockdata",
                    created: 898726,
                    deposit: 16666666500,
                    friends: [
                      "5Da6BeYLC3BRvS2H3bQ6JWgMGZtqKGdaoKMPhdtYMf56VaCU",
                    ])
              ],
            ));
  }

  Future<Result<dynamic>> vouch({required String recovererAccount, required String lostAccount}) async {
    print("vouch for recovering $lostAccount on behalf of $recovererAccount");
    return Future.delayed(const Duration(milliseconds: 500), () => Result.value("Ok"));
  }

  /// Claim recovery
  /// after that account can make calls with asRecovered
  ///
  /// Also after that we can close, remove and cancel.
  ///
  /// Close recovery - claims some fees back
  /// Remove recovery - claims some fees back
  /// Cancel recovered - removes ability to call asRecovered
  ///
  Future<Result<dynamic>> claimRecovery({required String account, required String lostAccount}) async {
    print("claim recovered account $lostAccount");
    return Future.delayed(const Duration(milliseconds: 500), () => Result.value("Ok"));
  }

  Future<Result<dynamic>> asRecovered(
      {required String account, required String lostAccount, required dynamic polkadotCall}) async {
    print("make a call on behalf of $lostAccount");
    return Future.delayed(const Duration(milliseconds: 500), () => Result.value("Ok"));
  }

  /// This transfers all funds from recoveredAccount to the currently active account
  /// It's a shortcut to a transfer through asRecovered.
  Future<Result<dynamic>> recoverFundsFor({required String account, required String lostAccount}) async {
    print("transfer funds from $lostAccount to $account account");
    return Future.delayed(const Duration(milliseconds: 500), () => Result.value("Ok"));
  }

  ///
  /// As the controller of a recoverable account, close an active recovery process for your account.
  /// Payment: By calling this function, the recoverable account will receive the recovery deposit RecoveryDeposit placed by the rescuer.
  /// The dispatch origin for this call must be Signed and must be a recoverable account with an active recovery process for it.
  /// Parameters:
  /// rescuer: The account trying to rescue this recoverable account.
  ///
  /// Note: this can be used to end a malicious recovery attempt.
  ///
  Future<Result<dynamic>> closeRecovery({required String lostccount, required String rescuerAccount}) async {
    print("closing recovery on $lostccount by $rescuerAccount");
    return Future.delayed(const Duration(milliseconds: 500), () => Result.value("Ok"));
  }

  /// I am guessing this removes the "as_recovered" recovery entry from the pallet, freeing up some storage
  /// and recovering some fees.
  Future<Result<dynamic>> cancelRecovered(String recoveredAccount) async {
    print("cancel recovery for $recoveredAccount");
    return Future.delayed(const Duration(milliseconds: 500), () => Result.value("Ok"));
  }
}
