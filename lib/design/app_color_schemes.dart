import 'package:flutter/material.dart';

class AppColorSchemes {
  static ColorScheme darkColorScheme =
      // Allow the system to create all the colors it needs from the seed.
      ColorScheme.fromSeed(seedColor: const Color(0xFF293E84), brightness: Brightness.dark).copyWith(
    /// Error background and text colors
    error: const Color(0xFF212227),
    onError: const Color(0xFFFF2919),

    /// Primary background of app
    background: const Color(0xFF212227),
    onBackground: const Color(0xFFFFFFFF),

    /// Alternative background - currently the same as primary
    /// Used for card backgrounds that float above the background
    surface: const Color(0xFF293E84),
    onSurface: const Color(0xFFFFFFFF),
  );
}
