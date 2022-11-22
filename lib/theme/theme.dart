import 'package:flutter/material.dart';
import 'package:my_recipes/theme/widget_styles.dart';

class RecipeasyTheme {
  static getLightThemeData() {
    var themeData = ThemeData();

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.green[800],
          secondary: Colors.green[800],
          background: Colors.white,
          brightness: Brightness.light),
      inputDecorationTheme: ReusableStyleWidget.inputTheme(),
      outlinedButtonTheme: ReusableStyleWidget.outlinedButtonTheme(),
      textButtonTheme: ReusableStyleWidget.textButtonTheme(),
      textSelectionTheme: ReusableStyleWidget.textSelectionTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static getDarkThemeData() {
    var themeData = ThemeData();

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
          secondary: Colors.green[500],
          primary: Colors.green[500],
          background: Colors.black12,
          brightness: Brightness.dark),
      inputDecorationTheme: ReusableStyleWidget.inputTheme(isDark: true),
      outlinedButtonTheme:
          ReusableStyleWidget.outlinedButtonTheme(isDark: true),
      textButtonTheme: ReusableStyleWidget.textButtonTheme(isDark: true),
      textSelectionTheme: ReusableStyleWidget.textSelectionTheme(isDark: true),
    );
  }
}