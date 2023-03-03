// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/profile_avatar.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:hashed/utils/build_context_extension.dart';
import 'package:hashed/utils/double_extension.dart';
import 'package:hashed/utils/short_string.dart';
import 'package:intl/intl.dart';

class SendTransactionSuccessDialog extends StatelessWidget {
  final String amount;
  final String tokenSymbol;
  final FiatDataModel? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? fromImage;
  final String? fromName;
  final String fromAccount;
  final String transactionID;

  const SendTransactionSuccessDialog({
    super.key,
    required this.amount,
    required this.tokenSymbol,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.fromImage,
    this.fromName,
    required this.fromAccount,
    required this.transactionID,
  });

  factory SendTransactionSuccessDialog.fromPageCommand(ShowTransferSuccess pageCommand) {
    return SendTransactionSuccessDialog(
      amount: pageCommand.tokenDataModel.quantity.amount.seedsFormatted,
      tokenSymbol: pageCommand.tokenDataModel.quantity.symbol,
      fiatAmount: pageCommand.fiatAmount,
      fromAccount: pageCommand.tokenDataModel.from.address,
      fromImage: "",
      fromName: pageCommand.tokenDataModel.from.name,
      toAccount: pageCommand.tokenDataModel.to.address,
      toImage: "",
      toName: pageCommand.tokenDataModel.to.name,
      transactionID: pageCommand.transactionHash,
    );
  }

  Future<void> show(BuildContext context) {
    return showDialog<void>(context: context, barrierDismissible: false, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          singleLargeButtonTitle: "Close",
          children: [
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(amount, style: Theme.of(context).textTheme.headlineMedium),
                Padding(
                  padding: const EdgeInsets.only(top: 14, left: 4),
                  child: Text(tokenSymbol, style: Theme.of(context).textTheme.titleSmall),
                ),
              ],
            ),
            Text(fiatAmount?.asFormattedString() ?? "", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 30.0),
            DialogRow(
                imageUrl: toImage,
                account: toAccount.shorter,
                name: toName,
                toOrFromText: context.loc.transferTransactionSuccessTo),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Text(context.loc.transferTransactionSuccessDate, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 16),
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Row(
              children: [
                Text("Transaction ID: ", style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    transactionID,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  // color: AppColors.lightGreen6,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: transactionID))
                        .then((_) => eventBus.fire(ShowSnackBar(context.loc.transferTransactionSuccessCopiedMessage)));
                  },
                )
              ],
            ),
            Row(
              children: [
                Text(context.loc.transferTransactionSuccessStatus, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 16),
                Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                    child: Text(
                      context.loc.transferTransactionSuccessSuccessful,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DialogRow extends StatelessWidget {
  final String? imageUrl;
  final String account;
  final String? name;
  final String? toOrFromText;

  const DialogRow({super.key, this.imageUrl, required this.account, this.name, this.toOrFromText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(size: 60, image: imageUrl, account: account, nickname: name),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name ?? account, textAlign: TextAlign.start, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(account)
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.elliptical(4, 4))),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
            child: Text(toOrFromText!, style: Theme.of(context).textTheme.titleSmall),
          ),
        ),
      ],
    );
  }
}
