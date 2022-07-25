import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';

class ResetGuardiansConfirmationDialog extends StatelessWidget {
  final GestureTapCallback? onDismiss;
  final GestureTapCallback? onConfirm;

  const ResetGuardiansConfirmationDialog({
    super.key,
    this.onConfirm,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      iconPadding: 0,
      rightButtonTitle: "Reset",
      onRightButtonPressed: onConfirm,
      leftButtonTitle: "Cancel",
      onLeftButtonPressed: onDismiss,
      children: [
        const SizedBox(height: 20),
        Text("Reset Guardians?", style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
              'You will have to re-add all your guardian addresses if you choose to reset your current Guardian list.'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
