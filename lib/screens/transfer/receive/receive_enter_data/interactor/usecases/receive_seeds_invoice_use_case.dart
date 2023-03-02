import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/firebase_dynamic_link_service.dart';
import 'package:hashed/datasource/local/models/substrate_extrinsic_model.dart';
import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/models/tx_sender_data.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/local/signing_request_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/utils/result_extension.dart';

class ReceiveInvoiceUseCase extends InputUseCase<ReceiveInvoiceResponse, _Input> {
  final SigningRequestRepository _invoiceRepository = SigningRequestRepository();

  static _Input input({required TokenDataModel tokenAmount, String? memo}) =>
      _Input(tokenAmount: tokenAmount, memo: memo);

  @override
  Future<Result<ReceiveInvoiceResponse>> run(_Input input) async {
    final chainId = settingsStorage.currentNetwork;
    final sender = TxSenderData.signer;
    final extrinsic = SubstrateExtrinsicModel(module: 'balances', call: 'transfer', sender: sender);
    print("current acct ${settingsStorage.currentAccount}");
    final String to = accountService.currentAccount.address;
    print("to $to");

    final int amount = input.tokenAmount.unitAmount();
    final parameters = [to, amount];
    final transferTransaction = SubstrateTransactionModel(extrinsic: extrinsic, parameters: parameters);
    final signingRequest = SubstrateSigningRequestModel(chainId: chainId, transactions: [transferTransaction]);

    final signingRequestURL = _invoiceRepository.toUrl(signingRequest);

    if (signingRequestURL.isError) {
      return Result.error(signingRequestURL.asError!.error);
    } else {
      final ssrUrl = signingRequestURL.asValue!.value;

      print("url $ssrUrl");
      final Result<Uri> dynamicLink = await FirebaseDynamicLinkService().createDynamicLinkFromUri(Uri.parse(ssrUrl));

      return Result.value(ReceiveInvoiceResponse(ssrUrl, dynamicLink.valueOrNull));
    }
  }
}

class _Input {
  final TokenDataModel tokenAmount;
  final String? memo;

  _Input({required this.tokenAmount, required this.memo});
}

class ReceiveInvoiceResponse {
  final String invoice;
  final Uri? invoiceDeepLink;

  ReceiveInvoiceResponse(this.invoice, this.invoiceDeepLink);
}
