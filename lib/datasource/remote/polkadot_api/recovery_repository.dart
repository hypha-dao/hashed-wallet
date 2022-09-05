import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
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
      "",
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

  Future<String?> _removeRecovery({required String address}) async {
    final sender = TxSenderData(
      address,
      "",
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
}
