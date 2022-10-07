import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/extrinsics_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class BalancesRepository extends ExtrinsicsRepository {
  BalancesRepository(super.webView);

  Future<Result<dynamic>> sendTransfer({
    required String from,
    required String to,
    required int amount,
  }) async {
    final sender = TxSenderData(from);
    final txInfo = SubstrateTransactionModel(module: 'balances', call: 'transfer', sender: sender);
    final params = [to, amount];
    try {
      final res = await signAndSend(txInfo, params, onStatusChange: (status) {
        print("send onStatusChange: $status");
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // flutter: CONSOLE MESSAGE: {"path":"uid=49;keyring.sendTransaction","data":{"hash":"0x9281450109ea11eb5ea2b1c3453df031d3fea45572917bb9ed66bd49bf90218c","blockHash":"0x892a2a4c46fb83035e2fc211ff378a9c78801acf5012c12fef86b40b8715ce1c"}}
      // flutter: sendTx {hash: 0x9281450109ea11eb5ea2b1c3453df031d3fea45572917bb9ed66bd49bf90218c, blockHash: 0x892a2a4c46fb83035e2fc211ff378a9c78801acf5012c12fef86b40b8715ce1c}
      return Result.value(res["hash"]);
    } catch (err) {
      print('sendTransfer ERROR $err');
      return Result.error(err);
    }
  }
}
