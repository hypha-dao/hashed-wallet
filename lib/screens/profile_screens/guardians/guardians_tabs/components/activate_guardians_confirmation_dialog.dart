import 'package:flutter/material.dart';
import 'package:hashed/components/custom_dialog.dart';

class ActivateGuardiansConfirmationDialog extends StatelessWidget {
  final GestureTapCallback? onDismiss;
  final GestureTapCallback? onConfirm;

  const ActivateGuardiansConfirmationDialog({
    super.key,
    this.onConfirm,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      iconPadding: 0,
      rightButtonTitle: "Ok",
      onRightButtonPressed: onConfirm,
      leftButtonTitle: "Cancel",
      onLeftButtonPressed: onDismiss,
      children: [
        const SizedBox(height: 20),
        Text("Activate Guardians?", style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
              'Once you have activated your Guardians, you cannot change them unless they are reset. Make sure you give them a heads up and have a way to contact your guardians easily!'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
