// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/profile_avatar.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/remote/model/profile_model.dart';
import 'package:hashed/datasource/remote/model/transaction_model.dart';
import 'package:hashed/utils/build_context_extension.dart';
import 'package:hashed/utils/double_extension.dart';
import 'package:intl/intl.dart';

class ReceivePaidSuccessArgs {
  final TransactionModel transaction;
  final ProfileModel from;
  final FiatDataModel? fiatData;

  const ReceivePaidSuccessArgs(this.transaction, this.from, this.fiatData);
}

class ReceivePaidSuccessDialog extends StatelessWidget {
  final ReceivePaidSuccessArgs args;

  const ReceivePaidSuccessDialog(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          singleLargeButtonTitle: context.loc.genericCloseButtonTitle,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(context.loc.transferReceivePaidSuccessHeader)],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(args.transaction.doubleQuantity.seedsFormatted),
                Padding(
                  padding: const EdgeInsets.only(top: 14, left: 4),
                  child: Text(args.transaction.symbol),
                ),
              ],
            ),
            Text(args.fiatData?.asFormattedString() ?? ''),
            const SizedBox(height: 30.0),
            Row(
              children: [
                ProfileAvatar(
                  size: 60,
                  image: args.from.image,
                  account: args.transaction.from,
                  nickname: args.from.nickname,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(args.from.nickname, textAlign: TextAlign.start),
                        const SizedBox(height: 8),
                        Text(args.transaction.from)
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.elliptical(4, 4))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child:
                        Text(context.loc.transferReceivePaidSuccessFrom, style: Theme.of(context).textTheme.subtitle2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Text(context.loc.transferReceivePaidSuccessDate, style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(width: 16),
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text(context.loc.transferReceivePaidSuccessStatus, style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(width: 16),
                Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                    child: Text(
                      context.loc.transferReceivePaidSuccessButtonTitle,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
