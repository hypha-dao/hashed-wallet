import 'package:async/async.dart';
import 'package:hashed/datasource/remote/model/generic_transaction_model.dart';
import 'package:hashed/datasource/remote/model/profile_model.dart';
import 'package:hashed/datasource/remote/model/transaction_model.dart';

class SendTransactionResponse {
  final GenericTransactionModel transactionModel;
  final List<Result>? profiles;

  bool get isTransfer => TransactionModel.fromTransaction(transactionModel) != null;
  TransactionModel? get transferTransactionModel => TransactionModel.fromTransaction(transactionModel);
  ProfileModel? get parseToUser => profiles?[0].asValue?.value as ProfileModel?;
  ProfileModel? get parseFromUser => profiles?[1].asValue?.value as ProfileModel?;

  const SendTransactionResponse({required this.transactionModel, this.profiles});
}
