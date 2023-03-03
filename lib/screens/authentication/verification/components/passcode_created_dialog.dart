import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/utils/build_context_extension.dart';

class PasscodeCreatedDialog extends StatelessWidget {
  const PasscodeCreatedDialog({super.key});

  Future<void> show(BuildContext context) async {
    return showDialog<void>(context: context, barrierDismissible: false, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      singleLargeButtonTitle: context.loc.genericCloseButtonTitle,
      children: [
        Text(context.loc.verificationPasscodeDialogTitle),
        const SizedBox(height: 30.0),
        Text(
          context.loc.verificationPasscodeDialogSubTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
