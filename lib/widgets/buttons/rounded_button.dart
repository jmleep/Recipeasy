import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final Color fillColor;
  final Color textColor;
  final Color borderColor;
  final Function onPressed;

  RoundedButton(
      {this.buttonText,
      this.fillColor,
      this.textColor,
      this.borderColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: fillColor,
        onPressed: () {
          onPressed();
        },
        child: Container(
          child: Text(
            buttonText,
            style: TextStyle(color: textColor),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: borderColor),
        ));
  }
}
