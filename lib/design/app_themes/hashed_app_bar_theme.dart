import 'package:flutter/material.dart';
import 'package:hashed/design/app_color_schemes.dart';

class HashedAppBarTheme {
  static AppBarTheme get appBarDarkThemeData {
    return AppBarTheme(elevation: 0.0, color: AppColorSchemes.darkColorScheme.surfaceVariant);
  }
}
