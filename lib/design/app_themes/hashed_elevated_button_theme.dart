import 'package:flutter/material.dart';
import 'package:hashed/design/app_color_schemes.dart';

class HashedElevatedButtonTheme {
  static ElevatedButtonThemeData get elevatedButtonThemeDataDark {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: AppColorSchemes.darkColorScheme.secondaryContainer, // secondary container pops more - looks active
      onPrimary: AppColorSchemes.darkColorScheme.onSecondaryContainer,
      elevation: 0.0,
      padding: const EdgeInsets.all(16),
    ));
  }
}
