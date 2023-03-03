// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/navigation/navigation_service.dart';

class ScanTransactionSuccessDialog extends StatelessWidget {
  const ScanTransactionSuccessDialog({super.key});

  Future<void> show(BuildContext context) {
    return showDialog<void>(context: context, barrierDismissible: false, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          singleLargeButtonTitle: 'Done',
          onSingleLargeButtonPressed: () async {
            await NavigationService.of(context).goToHomeScreen();
          },
          children: [
            Text("Success", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30.0),
            Text(
              'Your action has been successfully processed.',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'Select Done to go back to the Wallet HomeScreen.',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
