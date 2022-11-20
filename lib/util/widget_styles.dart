import 'package:flutter/material.dart';

class ReusableStyleWidget {
  static InputDecoration inputDecoration(BuildContext context, String hint) {
    var primaryColor = Theme.of(context).primaryColor;

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
}
