import 'package:flutter/material.dart';
import 'package:seeds/design/app_color_schemes.dart';

class SeedsAppTheme {
  //canvasColor: BottomNavigationBar background color
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.darkColorScheme,
      canvasColor: AppColorSchemes.darkColorScheme.background,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
      // appBarTheme: HashedAppBarTheme.appBarThemeData,
      // canvasColor: AppColorSchemes.darkColorScheme.background,
      // fontFamily: 'SFProDisplay',
      // textTheme: SeedsTextTheme.darkTheme,
      // inputDecorationTheme: SeedsInputDecorationTheme.darkTheme,
      // snackBarTheme: HashedSnackBarTheme.snackBarThemeData,
    );
  }
}
