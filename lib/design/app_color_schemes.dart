import 'package:flutter/material.dart';
import 'package:seeds/design/app_dark_colors.dart';
import 'package:seeds/design/app_light_colors.dart';

class AppColorSchemes {
  // TODO(gguij004): not completed or being used yet, most colors are just there for testing.
  // orange colors are for those missing in the pallet in figma
  // surface: AppBar color
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: AppDarkColors.primary,
    onPrimary: AppDarkColors.onPrimary,
    primaryContainer: AppDarkColors.primaryContainer,
    onPrimaryContainer: AppDarkColors.onPrimaryContainer,
    secondary: AppDarkColors.secondary,
    onSecondary: AppDarkColors.onSecondary,
    secondaryContainer: AppDarkColors.secondaryContainer,
    onSecondaryContainer: AppDarkColors.onSecondaryContainer,
    tertiary: AppDarkColors.tertiary,
    onTertiary: AppDarkColors.onTertiary,
    tertiaryContainer: AppDarkColors.tertiaryContainer,
    onTertiaryContainer: AppDarkColors.onSecondaryContainer,
    error: AppDarkColors.error,
    onError: AppDarkColors.onError,
    errorContainer: AppDarkColors.errorContainer,
    onErrorContainer: AppDarkColors.onErrorContainer,
    background: AppDarkColors.background,
    onBackground: AppDarkColors.onBackground,
    surface: AppDarkColors.surface,
    onSurface: AppDarkColors.onSurface,
    surfaceVariant: AppDarkColors.surfaceVariant,
    onSurfaceVariant: AppDarkColors.onSurfaceVariant,
    outline: AppDarkColors.outLine,
    brightness: Brightness.dark,
    surfaceTint: Colors.deepOrange,
    inversePrimary: Colors.deepOrange,
    inverseSurface: Colors.deepOrange,
    onInverseSurface: Colors.deepOrange,
    shadow: Colors.deepOrange,
  );

  // TODO(gguij004): not completed, to work on it after the darkScheme.
  static const lightColorScheme = ColorScheme(
    primary: AppLightColors.primary,
    onPrimary: AppLightColors.onPrimary,
    primaryContainer: AppLightColors.primaryContainer,
    onPrimaryContainer: AppLightColors.onPrimaryContainer,
    secondary: AppLightColors.secondary,
    onSecondary: AppLightColors.onSecondary,
    secondaryContainer: AppLightColors.secondaryContainer,
    onSecondaryContainer: AppLightColors.onSecondaryContainer,
    tertiary: AppLightColors.tertiary,
    onTertiary: AppLightColors.onTertiary,
    tertiaryContainer: AppLightColors.tertiaryContainer,
    onTertiaryContainer: AppLightColors.onSecondaryContainer,
    error: AppLightColors.error,
    onError: AppLightColors.onError,
    errorContainer: AppLightColors.errorContainer,
    onErrorContainer: AppLightColors.onErrorContainer,
    background: AppLightColors.background,
    onBackground: AppLightColors.onBackground,
    surface: AppLightColors.surface,
    onSurface: AppLightColors.onSurface,
    surfaceVariant: AppLightColors.surfaceVariant,
    onSurfaceVariant: AppLightColors.onSurfaceVariant,
    outline: AppLightColors.outLine,
    brightness: Brightness.light,
    surfaceTint: Colors.deepOrange,
    inversePrimary: Colors.deepOrange,
    inverseSurface: Colors.deepOrange,
    onInverseSurface: Colors.deepOrange,
    shadow: Colors.deepOrange,
  );
}
