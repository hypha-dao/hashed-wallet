import 'package:async/async.dart';

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
  Future<Result> run(TransactionData transactionData, String? callback) {
    // [POLKA] implement
    return Future.delayed(Duration.zero, () => Result(() => null));
  }
}
