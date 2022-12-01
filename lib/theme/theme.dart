import 'package:flutter/material.dart';
import 'package:my_recipes/theme/widget_styles.dart';

class RecipeasyTheme {
  static getLightThemeData() {
    var themeData = ThemeData();

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.green[800],
          secondary: Color.fromRGBO(59, 133, 136, 1.0),
          background: Colors.white,
          onSurface: Colors.black,
          onPrimary: Colors.white,
          brightness: Brightness.light,
          onBackground: Colors.black),
      inputDecorationTheme: ReusableStyleWidget.inputThemeBordered(),
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
          secondary: Color.fromRGBO(
              59, 133, 136, 1.0), //Color.fromRGBO(76, 171, 175, 1),
          primary: Colors.green[600],
          onSurface: Colors.white,
          onPrimary: Colors.white,
          brightness: Brightness.dark,
          background: Colors.grey[900],
          onBackground: Colors.white),
      inputDecorationTheme:
          ReusableStyleWidget.inputThemeBordered(isDark: true),
      outlinedButtonTheme:
          ReusableStyleWidget.outlinedButtonTheme(isDark: true),
      textButtonTheme: ReusableStyleWidget.textButtonTheme(isDark: true),
      textSelectionTheme: ReusableStyleWidget.textSelectionTheme(isDark: true),
      scaffoldBackgroundColor: Colors.grey[900],
      textTheme: TextTheme()
          .apply(bodyColor: Colors.white, displayColor: Colors.white),
      unselectedWidgetColor: Colors.white,
    );
  }
}
