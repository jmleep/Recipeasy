import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final Color fillColor;
  final Color textColor;
  final Color borderColor;
  final Function onPressed;
  final double leftPadding;
  final double rightPadding;

  RoundedButton(
      {this.buttonText = 'Empty text',
      this.fillColor = Colors.white30,
      this.textColor,
      this.borderColor = Colors.blueGrey,
      this.onPressed,
      this.leftPadding = 0,
      this.rightPadding = 0});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onPressed();
        },
        child: Container(
          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
          child: Text(
            buttonText,
            style: textColor != null ? TextStyle(color: textColor) : null,
          ),
        ),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => fillColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: borderColor),
            ))));
  }
}
