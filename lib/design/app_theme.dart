import 'package:flutter/material.dart';
import 'package:seeds/design/app_color_schemes.dart';
import 'package:seeds/design/app_themes/hashed_app_bar_theme.dart';
import 'package:seeds/design/app_themes/hashed_elevated_button_theme.dart';

class SeedsAppTheme {
  //canvasColor: BottomNavigationBar background color
  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        colorScheme: AppColorSchemes.darkColorScheme,
        canvasColor: AppColorSchemes.darkColorScheme.surfaceVariant,
        elevatedButtonTheme: HashedElevatedButtonTheme.elevatedButtonThemeData,
        appBarTheme: HashedAppBarTheme.appBarDarkThemeData
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
    );
  }
}
