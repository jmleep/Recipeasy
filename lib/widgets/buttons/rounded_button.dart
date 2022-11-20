import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final Color fillColor;
  final Color textColor;
  final Color borderColor;
  final Function onPressed;

  RoundedButton(
      {this.buttonText = 'Empty text',
      this.fillColor = Colors.white30,
      this.textColor,
      this.borderColor = Colors.blueGrey,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onPressed();
        },
        child: Container(
          child: Text(
            buttonText,
            style: textColor != null ? TextStyle(color: textColor) : null,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => fillColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: borderColor),
        ))));
  }
}
