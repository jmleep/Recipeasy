import 'package:flutter/material.dart';

class ReusableStyleWidget {
  static InputDecoration inputDecoration(BuildContext context, String hint) {
    var primaryColor = Theme.of(context).colorScheme.primary;

    return InputDecoration(
        //hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(color: primaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusColor: primaryColor,
        //hintStyle: TextStyle(color: Colors.deepOrange),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColor)));
  }

  static outlinedButtonTheme({bool isDark = false}) => OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(20),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              isDark ? Colors.green[500] : Colors.green[800]),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      );

  static inputTheme({bool isDark = false}) => InputDecorationTheme(
      labelStyle:
          TextStyle(color: isDark ? Colors.green[500] : Colors.green[800]),
      focusColor: isDark ? Colors.green[500] : Colors.green[800],
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: isDark ? Colors.green[500] : Colors.green[800])),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: isDark ? Colors.green[500] : Colors.green[800])));

  static textButtonTheme({bool isDark = false}) => TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
              isDark ? Colors.green[500] : Colors.green[800])));

  static textSelectionTheme({bool isDark = false}) => TextSelectionThemeData(
        cursorColor: isDark ? Colors.green[500] : Colors.green[800],
        selectionColor: Colors.green[300],
        selectionHandleColor: Colors.green[800],
      );
}
