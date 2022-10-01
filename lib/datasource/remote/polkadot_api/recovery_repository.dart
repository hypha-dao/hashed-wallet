import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/extrinsics_repository.dart';
import 'package:hashed/utils/result_extension.dart';

/// Documentation here:
/// https://polkadot.js.org/docs/substrate/extrinsics/#recovery
class RecoveryRepository extends ExtrinsicsRepository {
  RecoveryRepository(super.webView);

  /// Activates your guardians - Min 2 for now. (UI enforced)
  Future<Result> createRecovery(String address, GuardiansConfigModel guardians) async {
    print("create recovery: ${guardians.toJson()}");
    final sender = TxSenderData(address);
    final txInfo = SubstrateTransactionModel('recovery', 'createRecovery', sender);
    final guardianAddresses = guardians.guardianAddresses;
    guardianAddresses.sort();
    final params = [guardianAddresses, guardians.threshold, guardians.delayPeriod];

    try {
      final res = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("onStatusChange: $status");
      });
      return Result.value(res.toString());
    } catch (err, s) {
      print('sendCreateRecovery error: $err');
      print(s);
      return Result.error(err);
    }
  }

  Future<Result<GuardiansConfigModel>> getRecoveryConfig(String address, {bool mock = false}) async {
    print("get guardians for $address");

    if (mock) {
      return Result.value(GuardiansConfigModel.mock);
    }

    // TODO(n13): Create a mapper for polkadot API results - similar to httpmapper
    // then add model mappers for all the different possible responses.
    // But, make it work first -
    try {
      final code = 'api.query.recovery.recoverable("$address")';
      final res = await evalJavascript(code: code);
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

  /// Removes user's guardians. User must Start from scratch.
  /// Recovers fees.
  Future<Result> removeRecovery({required String address}) async {
    print('removeRecovery for $address');

    final sender = TxSenderData(address);
    final txInfo = SubstrateTransactionModel('recovery', 'removeRecovery', sender);
    final params = [];
    try {
      final res = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("onStatusChange: $status");
      });

      return Result.value(res);
    } on Exception catch (err) {
      return Result.error(err);
    }
  }

  Future<Result<dynamic>> initiateRecovery({required String address, required String lostAccount}) async {
    print('initiateRecovery for $lostAccount');
    final sender = TxSenderData(address);
    final txInfo = SubstrateTransactionModel('recovery', 'initiateRecovery', sender);
    final params = [lostAccount];
    try {
      final hash = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("initiateRecovery - onStatusChange: $status");
      });
      return Result.value(hash.toString());
    } catch (err, s) {
      print('initiateRecovery error $err');
      print(s);
      return Result.error(err);
    }
  }

  /// return recoveries that are currently in process for the address in question
  /// Params: Address to be recovered
  Future<Result<List<ActiveRecoveryModel>>> getActiveRecoveries(String address, {bool mock = false}) async {
    print("get active recovery for $address");

    if (mock) {
      return Future.delayed(const Duration(milliseconds: 500), () => Result.value([ActiveRecoveryModel.mock]));
    }

    try {
      final code = 'api.query.recovery.activeRecoveries.entries("$address")';
      final transformer = '''
      res.map(([k, v]) => { 
        return { 
          key: k, 
          lostAccount: k.toHuman()[0],
          rescuer: k.toHuman()[1],
          data: v.toJSON() 
        } 
      })''';

      final res = await evalJavascript(code: code, transformer: transformer);

      final list = List.from(res);
      final recoveries = list.map((e) => ActiveRecoveryModel.fromJson(e)).toList();

      return Result.value(recoveries);
    } catch (err, stacktrace) {
      print('getActiveRecoveries error: $err');
      print(stacktrace);
      return Result.error(err);
    }
  }

  Future<Result<ActiveRecoveryModel?>> getActiveRecoveriesForLostaccount(
    String rescuer,
    String lostAccount, {
    bool mock = false,
  }) async {
    print("get active recovery for $rescuer and $lostAccount");

    if (mock) {
      return Future.delayed(const Duration(milliseconds: 500), () => Result.value(ActiveRecoveryModel.mock));
    }

    try {
      final code = 'api.query.recovery.activeRecoveries("$lostAccount", "$rescuer")';
      final res = await evalJavascript(code: code);

      if (res == null) {
        return Result.value(null);
      }

      final recovery = ActiveRecoveryModel.fromJsonSingle(rescuer: rescuer, lostAccount: lostAccount, json: res);

      return Result.value(recovery);
    } catch (err, stacktrace) {
      print('getActiveRecoveries error: $err');
      print(stacktrace);
      return Result.error(err);
    }
  }

  Future<Result<dynamic>> vouch(
      {required String address, required String lostAccount, required String recovererAccount}) async {
    print('vouch for $recovererAccount recovering $lostAccount');
    final sender = TxSenderData(address);
    final txInfo = SubstrateTransactionModel('recovery', 'vouchRecovery', sender);
    final params = [lostAccount, recovererAccount];
    try {
      final hash = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("vouch - onStatusChange: $status");
      });
      return Result.value(hash.toString());
    } catch (err, s) {
      print('initiateRecovery error $err');
      print(s);
      return Result.error(err);
    }
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
  Future<Result<dynamic>> claimRecovery({required String rescuer, required String lostAccount}) async {
    print("claimRecovery on $lostAccount by $rescuer");

    if (rescuer != accountService.currentAccount.address) {
      // Note: signAndSend does not handle the case well where there is no key for an account
      // it just silently dies.
      throw UnimplementedError("curently only the current account - key holder - can make a recovery");
    }

    final sender = TxSenderData(rescuer);
    final txInfo = SubstrateTransactionModel('recovery', 'claimRecovery', sender);
    final params = [lostAccount];

    try {
      final hash = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("claimRecovery - onStatusChange: $status");
      });

      return Result.value(hash.toString());
    } catch (err, s) {
      print('claimRecovery error $err');
      print(s);
      return Result.error(err);
    }
  }

  /// Make a call on behalf of "lostAccount", using address
  /// address must be a proxy for lostAccount - the result of a successful recovery.
  Future<Result<dynamic>> asRecovered({
    required String address,
    required String lostAccount,
    required String pallet,
    required String call,
    required List params,
  }) async {
    print("make a call on behalf of $lostAccount");
    final proxySender = TxSenderData(address);
    final lostAccountSender = TxSenderData(lostAccount);
    final txInfo = SubstrateTransactionModel(pallet, call, lostAccountSender, proxy: proxySender);

    try {
      final hash = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("asRecovered - onStatusChange: $status");
      });
      return Result.value(hash.toString());
    } catch (err, s) {
      print('asRecovered error $err');
      print(s);
      return Result.error(err);
    }
  }

  /// This transfers all funds from lostAccount to the currently active account
  /// It's a shortcut to a transfer through asRecovered.
  Future<Result<dynamic>> recoverAllFunds({required String address, required String lostAccount}) async {
    print("recover funds of $lostAccount");

    final lostAccountSender = TxSenderData(lostAccount);
    final txInfo =
        SubstrateTransactionModel('balances', 'transferAll', lostAccountSender, proxy: TxSenderData(address));
    final params = [address, false];

    try {
      final hash = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("recoverAllFunds - onStatusChange: $status");
      });
      return Result.value(hash.toString());
    } catch (err, s) {
      print('recoverAllFunds error $err');
      print(s);
      return Result.error(err);
    }
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
  Future<Result<dynamic>> closeRecovery({required String account, required String rescuerAccount}) async {
    print("closing recovery on $account by $rescuerAccount");
    final sender = TxSenderData(account);
    final txInfo = SubstrateTransactionModel('recovery', 'closeRecovery', sender);
    final params = [rescuerAccount];

    try {
      final hash = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("closeRecovery - onStatusChange: $status");
      });
      return Result.value(hash.toString());
    } catch (err, s) {
      print('closeRecovery error $err');
      print(s);
      return Result.error(err);
    }
  }

  /// I am guessing this removes the "as_recovered" recovery entry from the pallet, freeing up some storage
  /// and recovering some fees.
  Future<Result<dynamic>> cancelRecovered({required String account, required String lostAccount}) async {
    print("cancel recovery on $lostAccount");
    final sender = TxSenderData(account);
    final txInfo = SubstrateTransactionModel('recovery', 'cancelRecovered', sender);
    final params = [lostAccount];

    try {
      final hash = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("cancelRecovered - onStatusChange: $status");
      });
      return Result.value(hash.toString());
    } catch (err, s) {
      print('cancelRecovered error $err');
      print(s);
      return Result.error(err);
    }
  }

  /// return recoveries that are currently in process for the address in question
  /// Params: Address to be recovered
  Future<Result<List<String>>> getProxies(String address, {bool mock = false}) async {
    print("get proxy for $address");

    if (mock) {
      return Future.delayed(const Duration(milliseconds: 500), () => Result.value(["5x01testdata", "5x02testdata"]));
    }

    try {
      final code = 'api.query.recovery.proxy("$address")';

      final res = await evalJavascript(code: code);
      print("res: $res");
      // TODO(n13): Fix this - not sure what this call returns - a list or... ???
      // need to experiment with this

      if (res == null) {
        return Result.value([]);
      }
      final list = List<dynamic>.from(res);

      // TODO(n13): Parse the list of tuples into a single list of string.

      return Result.value([]);
    } catch (err, stacktrace) {
      print('getProxies error: $err');
      print(stacktrace);
      return Result.error(err);
    }
  }
}
