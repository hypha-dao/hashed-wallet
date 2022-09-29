// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hashed/design/app_color_schemes.dart';

class HashedElevatedButtonTheme {
  static ElevatedButtonThemeData get elevatedButtonThemeDataDark {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: AppColorSchemes.darkColorScheme.primary, // secondary container pops more - looks active
      onPrimary: AppColorSchemes.darkColorScheme.onPrimary,
      elevation: 0.0,
      padding: const EdgeInsets.all(16),
    ));
  }
}
