import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/domain-shared/page_command.dart';

class ShowSendConfirmDialog extends PageCommand {
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;

  ShowSendConfirmDialog({
    required this.tokenAmount,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
  });
}
