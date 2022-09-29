import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/components/custom_dialog.dart';

class RecoverSuccessDialog extends StatelessWidget {
  final VoidCallback? onDismiss;
  const RecoverSuccessDialog({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          onSingleLargeButtonPressed: onDismiss,
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          singleLargeButtonTitle: "Done",
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text("Recovery successful!")],
            ),
          ],
        ),
      ),
    );
  }
}
