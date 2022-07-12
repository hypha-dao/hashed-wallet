import 'package:flutter/material.dart';
import 'package:seeds/design/app_color_schemes.dart';

class SeedsAppTheme {
  //canvasColor: BottomNavigationBar background color
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.darkColorScheme,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
    );
  }
}
