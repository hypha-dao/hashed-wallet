import 'package:flutter/material.dart';

enum ButtonsType { sendButton, receiveButton }

class WalletButtons extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonsType buttonType;

  const WalletButtons({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.buttonType = ButtonsType.sendButton,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle(context),
      onPressed: onPressed,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    if (isLoading) {
      return const SizedBox(height: 22, width: 22, child: CircularProgressIndicator());
    } else {
      return Text(title);
    }
  }

  ButtonStyle? buttonStyle(BuildContext context) {
    final buttonStyle = ElevatedButtonTheme.of(context).style;
    switch (buttonType) {
      case ButtonsType.sendButton:
        return buttonStyle?.merge(
          ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
        );
      case ButtonsType.receiveButton:
        return buttonStyle?.merge(
          ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
        );
    }
  }
}
