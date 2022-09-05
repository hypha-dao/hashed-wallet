import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/extrinsics_repository.dart';

class RecoveryRepositry extends ExtrinsicsRepository {
  RecoveryRepositry(super.webView);

  Future<String> createRecovery({
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

  Future<String?> removeRecovery({required String address}) async {
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
}
