import 'package:flutter/material.dart';
import 'package:seeds/design/app_color_schemes.dart';

class HashedSnackBarTheme {
  static SnackBarThemeData get snackBarThemeData {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      contentTextStyle: TextStyle(color: AppColorSchemes.darkColorScheme.onBackground),
    );
  }
}
