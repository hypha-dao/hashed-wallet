import 'package:flutter/material.dart';

class HashedElevatedButtonTheme {
  static ElevatedButtonThemeData get elevatedButtonThemeData {
    return ElevatedButtonThemeData(
        style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0.0),
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
    ));
  }
}
