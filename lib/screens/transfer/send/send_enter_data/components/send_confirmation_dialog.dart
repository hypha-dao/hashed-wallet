import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/profile_avatar.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/remote/model/token_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/short_string.dart';

class SendConfirmationDialog extends StatelessWidget {
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;
  final String? fee;
  final VoidCallback onSendButtonPressed;

  SendConfirmationDialog({
    super.key,
    required this.tokenAmount,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
    this.fee,
    required this.onSendButtonPressed,
  });

  late final Stream<String> _feeStream = (() {
    late final StreamController<String> controller;
    controller = StreamController<String>(
      onListen: () async {
        final result = await polkadotRepository.balancesRepository.estimateTransferFees(
            from: accountService.currentAccount.address, to: toAccount, amount: tokenAmount.unitAmount());
        if (result.isValue) {
          final val = result.asValue!.value;
          final amount = tokenAmount.amountFromUnit("${val.partialFee}");
          final tokenModel = tokenAmount.copyWith(amount);
          controller.add(tokenModel.amountStringWithSymbol());
        }
        await controller.close();
      },
    );
    return controller.stream;
  })();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Image(
            image: AssetImage(tokenAmount.logoUrlAsset ?? hashedToken.logoUrl),
            fit: BoxFit.fill,
          ),
        ],
      ),
      iconBackground: Theme.of(context).colorScheme.onSurface,
      onRightButtonPressed: () {
        onSendButtonPressed.call();
        Navigator.of(context).pop();
      },
      leftButtonTitle: 'Edit',
      rightButtonTitle: 'Send',
      topDecorationWidget: SvgPicture.asset("assets/images/transfer/arrow_up.svg"),
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tokenAmount.amountString(), style: Theme.of(context).textTheme.headlineMedium),
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 4),
              child: Text(tokenAmount.symbol, style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        ),
        Text(fiatAmount?.asFormattedString() ?? "", style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 30.0),
        DialogRow(imageUrl: toImage, account: toAccount.shorter, name: toName, toOrFromText: ""),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Network Fee", textAlign: TextAlign.left, style: Theme.of(context).textTheme.titleSmall),
            StreamBuilder<String>(
                stream: _feeStream,
                initialData: "...",
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const SizedBox();
                    case ConnectionState.active:
                      return const SizedBox();
                    case ConnectionState.waiting:
                      return SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onBackground,
                          strokeWidth: 1,
                        ),
                      );
                    case ConnectionState.done:
                      return Text(snapshot.data ?? "?",
                          textAlign: TextAlign.right, style: Theme.of(context).textTheme.titleSmall);
                  }
                }),
          ],
        ),
        const SizedBox(height: 40.0),
        if (memo != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Memo", textAlign: TextAlign.right, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 16.0),
              Flexible(
                child: Text(memo!,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleSmall),
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
                Text(name ?? account, textAlign: TextAlign.start, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(account)
              ],
            ),
          ),
        ),
        // ignore: use_decorated_box
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
