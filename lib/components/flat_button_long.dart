import 'package:flutter/material.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

/// A long flat widget button with rounded corners
class FlatButtonLong extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;

  const FlatButtonLong(
      {super.key, required this.title, required this.onPressed, this.enabled = true, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        //color: AppColors.newPrimary,
        // disabledTextColor: AppColors.grey3,
        // disabledColor: AppColors.newPrimaryLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultButtonBorderRadius)),
        onPressed: enabled ? onPressed : null,
        child: isLoading
            ? Container(
                width: 17,
                height: 17,
                child: const CircularProgressIndicator(
                  // color: AppColors.white,
                  strokeWidth: 3,
                ))
            : Text(title),
      ),
    );
  }
}
