import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';

abstract class TransactionPageCommand extends PageCommand {}

class ShowTransactionSuccess extends TransactionPageCommand {
  final String transactionHash;

  ShowTransactionSuccess(this.transactionHash);
}

class ShowTransferSuccess extends TransactionPageCommand {
  final SendTransaction tokenDataModel;
  final String transactionHash;
  FiatDataModel? fiatAmount;

  ShowTransferSuccess({
    required this.tokenDataModel,
    required this.transactionHash,
    this.fiatAmount,
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
