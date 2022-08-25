import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/profile_avatar.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/utils/build_context_extension.dart';
import 'package:hashed/utils/short_string.dart';

class SendConfirmationDialog extends StatelessWidget {
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;
  final VoidCallback onSendButtonPressed;

  const SendConfirmationDialog({
    super.key,
    required this.tokenAmount,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
    required this.onSendButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Image(
            image: AssetImage(tokenAmount.asset),
            fit: BoxFit.fill,
          ),
        ],
      ),
      iconBackground: Theme.of(context).colorScheme.onSurfaceVariant,
      onRightButtonPressed: () {
        onSendButtonPressed.call();
        Navigator.of(context).pop();
      },
      leftButtonTitle: context.loc.transferSendEditButtonTitle,
      rightButtonTitle: context.loc.transferSendSendButtonTitle,
      topDecorationWidget: SvgPicture.asset("assets/images/transfer/arrow_up.svg"),
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tokenAmount.amountString(), style: Theme.of(context).textTheme.headline4),
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 4),
              child: Text(tokenAmount.symbol, style: Theme.of(context).textTheme.subtitle2),
            ),
          ],
        ),
        Text(fiatAmount?.asFormattedString() ?? "", style: Theme.of(context).textTheme.subtitle2),
        const SizedBox(height: 30.0),
        DialogRow(imageUrl: toImage, account: toAccount.shorter, name: toName, toOrFromText: ""),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Network Fee", textAlign: TextAlign.left, style: Theme.of(context).textTheme.subtitle2),
            Text("TBD", textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2),
          ],
        ),
        const SizedBox(height: 40.0),
        if (memo != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Memo", textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2),
              const SizedBox(width: 16.0),
              Flexible(
                child: Text(memo!,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
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
                Text(name ?? account, textAlign: TextAlign.start, style: Theme.of(context).textTheme.button),
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
            child: Text(toOrFromText!, style: Theme.of(context).textTheme.subtitle2),
          ),
        ),
      ],
    );
  }
}
