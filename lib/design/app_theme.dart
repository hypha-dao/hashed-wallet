import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hashed/design/app_color_schemes.dart';
import 'package:hashed/design/app_themes/hashed_app_bar_theme.dart';
import 'package:hashed/design/app_themes/hashed_card_theme.dart';
import 'package:hashed/design/app_themes/hashed_elevated_button_theme.dart';

class SeedsAppTheme {
  //canvasColor: BottomNavigationBar background color
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.darkColorScheme,
      canvasColor: AppColorSchemes.darkColorScheme.background,
      elevatedButtonTheme: HashedElevatedButtonTheme.elevatedButtonThemeDataDark,
      appBarTheme: HashedAppBarTheme.appBarDarkThemeData,
      cardTheme: HashedCardTheme.appCardThemeData,
      textTheme: GoogleFonts.sourceSansProTextTheme(ThemeData.dark().textTheme),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
    );
  }
}
