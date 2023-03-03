import 'package:flutter/material.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/domain-shared/global_error.dart';

class FullPageErrorIndicator extends StatelessWidget {
  final String? errorMessage;
  final String? buttonTitle;
  final VoidCallback? buttonOnPressed;

  const FullPageErrorIndicator({this.errorMessage, this.buttonTitle, this.buttonOnPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              errorMessage ?? GlobalError.unknown.localizedDescription(context),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
      ),
      if (buttonTitle != null && buttonOnPressed != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: FlatButtonLong(title: buttonTitle!, onPressed: buttonOnPressed),
        ),
    ]);
  }
}
