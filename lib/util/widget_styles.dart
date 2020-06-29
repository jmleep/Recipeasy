import 'package:flutter/material.dart';

class ReusableStyleWidget {
  static InputDecoration inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
        //hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusColor: Theme.of(context).primaryColor,
        //hintStyle: TextStyle(color: Colors.deepOrange),
        focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepOrange)),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey)));
  }
}
