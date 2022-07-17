import 'package:flutter/material.dart';

class NoGuardiansWidget extends StatelessWidget {
  final String message;

  const NoGuardiansWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text(message),
    ));
  }
}
