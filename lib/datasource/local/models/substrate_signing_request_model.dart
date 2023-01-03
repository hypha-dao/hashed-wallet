import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';

class SubstrateSigningRequestModel {
  final String chainId;
  final List<SubstrateTransactionModel> transactions;

  const SubstrateSigningRequestModel({required this.chainId, required this.transactions});

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
}
