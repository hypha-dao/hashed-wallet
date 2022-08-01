import 'package:async/async.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';

// simple tx data
class TransactionData {
  String from;
  String to;
  String symbol;
  double amount;
  TransactionData({
    required this.from,
    required this.to,
    required this.symbol,
    required this.amount,
  });
}

class SendTransactionUseCase {
  // ignore: unused_field
  final PolkadotRepository _polkadotRepository = PolkadotRepository();

  Future<Result> run(TransactionData transactionData, String? callback) {
    // [POLKA] implement
    return Future.delayed(Duration.zero, () => Result(() => null));
  }
}
