import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/utils/build_context_extension.dart';

class BiometricEnabledDialog extends StatelessWidget {
  const BiometricEnabledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const Icon(Icons.fingerprint, size: 52, color: AppColors.green1),
      singleLargeButtonTitle: context.loc.securityBiometricEnabledConfirmationButtonTitle,
      children: [
        Text(context.loc.securityBiometricEnabledTitle),
        const SizedBox(height: 24.0),
        Text(
          context.loc.securityBiometricEnabledDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
