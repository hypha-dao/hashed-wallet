import 'package:flutter/material.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/profile_avatar.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/i18n/profile_screens/guardians/guardians.i18n.dart';

class RemoveGuardianConfirmationDialog extends StatelessWidget {
  final Account guardian;
  final GestureTapCallback? onDismiss;
  final GestureTapCallback? onConfirm;

  const RemoveGuardianConfirmationDialog({
    super.key,
    this.onConfirm,
    this.onDismiss,
    required this.guardian,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      iconPadding: 0,
      icon: ProfileAvatar(
        size: 80,
        account: guardian.address,
        nickname: guardian.name,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          // color: AppColors.blue,
        ),
      ),
      rightButtonTitle: "Ok".i18n,
      onRightButtonPressed: onConfirm,
      leftButtonTitle: "Cancel".i18n,
      onLeftButtonPressed: onDismiss,
      children: [
        const SizedBox(height: 20),
        Text("Remove Guardian?".i18n, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Are you sure you want to remove '.i18n,
                style: Theme.of(context).textTheme.titleSmall,
                children: <TextSpan>[
                  TextSpan(text: guardian.name, style: Theme.of(context).textTheme.titleSmall),
                  TextSpan(text: ' as your Guardian?'.i18n, style: Theme.of(context).textTheme.titleSmall)
                ]),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
