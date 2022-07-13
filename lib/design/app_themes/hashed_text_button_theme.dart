import 'package:flutter/material.dart';

class HashedTextButtonTheme {
  static TextButtonThemeData get textButtonThemeData {
    return TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
        ));
  }
}
