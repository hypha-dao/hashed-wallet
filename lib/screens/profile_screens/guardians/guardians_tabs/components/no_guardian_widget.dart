import 'package:flutter/material.dart';

class NoGuardiansWidget extends StatelessWidget {
  final String message;

  const NoGuardiansWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(62.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 34,
              )),
        ],
      ),
    );
  }
}
