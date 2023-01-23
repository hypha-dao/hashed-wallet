import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_action.dart';

class SubstrateSigningRequestModel {
  final String chainId;
  final String? callback;
  final List<SubstrateTransactionModel> transactions;

  const SubstrateSigningRequestModel({required this.chainId, required this.transactions, this.callback});

  factory SubstrateSigningRequestModel.fromJson(Map<String, dynamic> json) {
    final List<SubstrateTransactionModel> transactions = List.of(
      List.of(json['transactions']).map(
        (e) => SubstrateTransactionModel.fromJson(e),
      ),
    );

    return SubstrateSigningRequestModel(
      chainId: json['chainId'],
      transactions: transactions,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'chainId': chainId,
        'transactions': List.of(transactions.map((e) => e.toJson())),
      };

  List<ScanConfirmationActionData> toSendConfirmationData() {
    return List.from(transactions.map((e) => e.toSendConfirmationActionData()));
  }
}
