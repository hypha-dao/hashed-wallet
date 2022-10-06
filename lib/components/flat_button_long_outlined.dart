import 'package:flutter/material.dart';
import 'package:hashed/domain-shared/ui_constants.dart';

/// A long flat widget button with rounded corners and white outline
class FlatButtonLongOutlined extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const FlatButtonLongOutlined({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(defaultButtonBorderRadius),
          ),
          onPressed: onPressed,
          child: Text(title)),
    );
  }
}
