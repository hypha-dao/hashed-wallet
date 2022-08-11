import 'package:flutter/material.dart';
import 'package:hashed/design/app_color_schemes.dart';

class HashedSnackBarTheme {
  static SnackBarThemeData get snackBarThemeData {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      contentTextStyle: TextStyle(color: AppColorSchemes.darkColorScheme.onBackground),
    );
  }
}
