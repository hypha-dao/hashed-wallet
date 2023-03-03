import 'package:flutter/material.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/utils/build_context_extension.dart';

class InviteLinkFailDialog extends StatelessWidget {
  const InviteLinkFailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const Icon(Icons.cancel_outlined, size: 60),
      singleLargeButtonTitle: context.loc.genericCloseButtonTitle,
      children: [
        Text(context.loc.signUpInviteCodeErrorTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24.0),
        Text(
          context.loc.signUpInviteCodeErrorDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
