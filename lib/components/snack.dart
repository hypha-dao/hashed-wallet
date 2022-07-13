import 'package:flutter/material.dart';

enum SnackType { info, success, failure }

class Snack extends SnackBar {
  final String title;
  final ScaffoldMessengerState scaffoldMessengerState;

  factory Snack(title, scaffoldMessengerState) {
    final Duration duration = const Duration(seconds: 4);

    return Snack._(title, scaffoldMessengerState, duration: duration);
  }

  Snack._(this.title, this.scaffoldMessengerState, {Key? key, required Duration duration})
      : super(
          key: key,
          duration: duration,
          content: Row(
            children: [
              Expanded(child: Text(title, textAlign: TextAlign.center)),
              InkWell(
                onTap: () => scaffoldMessengerState.hideCurrentSnackBar(),
                child: const Icon(Icons.close),
              ),
            ],
          ),
        );

  void show() => scaffoldMessengerState.showSnackBar(this);
}
