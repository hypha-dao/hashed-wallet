import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/remote/model/generic_transaction_model.dart';
import 'package:hashed/datasource/remote/model/profile_model.dart';
import 'package:hashed/datasource/remote/model/transaction_model.dart';
import 'package:hashed/domain-shared/page_command.dart';

abstract class TransactionPageCommand extends PageCommand {}

class ShowTransactionSuccess extends TransactionPageCommand {
  final GenericTransactionModel transactionModel;

  ShowTransactionSuccess(this.transactionModel);
}

class ShowTransferSuccess extends TransactionPageCommand {
  final TransactionModel transactionModel;
  ProfileModel? from;
  ProfileModel? to;
  FiatDataModel? fiatAmount;
  final bool shouldShowInAppReview;

  ShowTransferSuccess({
    required this.transactionModel,
    this.from,
    this.to,
    this.fiatAmount,
    required this.shouldShowInAppReview,
  });
}

class ShowInvalidTransactionReason extends TransactionPageCommand {
  final String reason;
  ShowInvalidTransactionReason(this.reason);
}

class ShowFailedTransactionReason extends TransactionPageCommand {
  final String title;
  final String details;
  ShowFailedTransactionReason({required this.title, required this.details});
}
