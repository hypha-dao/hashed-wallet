import 'package:flutter/material.dart';
import 'package:hashed/domain-shared/ui_constants.dart';

class ReceiveSelectionCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final GestureTapCallback onTap;

  const ReceiveSelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            icon,
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
