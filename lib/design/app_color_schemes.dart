import 'package:flutter/material.dart';

class AppColorSchemes {
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    /// Primary accent color. Use this for all primary accents in the app.
    /// Can also be used for buttons and active elements.
    primary: Color(0xFF293E84),
    onPrimary: Color(0xFFFFFFFF),

    /// Secondary accent color - a brighter neon-ish blue.
    secondary: Color(0xFF3E65EF),
    onSecondary: Color(0xFFFFFFFF),

    /// Error background and text colors
    error: Color(0xFF212227),
    onError: Color(0xFFFF2919),

    /// Primary background of app
    background: Color(0xFF212227),
    onBackground: Color(0xFFFFFFFF),

    /// Alternative background - currently the same as primary
    /// Used for card backgrounds that float above the background
    surface: Color(0xFF293E84),
    onSurface: Color(0xFFFFFFFF),
  );

  // TODO(n13): not in use.
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB6C4FF),
    onPrimary: Color(0xFFB6C4FF),
    secondary: Color(0xFFB6C4FF),
    onSecondary: Color(0xFFB6C4FF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFB6C4FF),
    background: Color(0xFFB6C4FF),
    onBackground: Color(0xFFB6C4FF),
    surface: Color(0xFFB6C4FF),
    onSurface: Color(0xFFB6C4FF),
  );
}
