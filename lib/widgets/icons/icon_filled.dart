import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilledIcon extends StatelessWidget {
  final IconData icon;
  final Color fillColor;
  final Color iconColor;

  FilledIcon({this.icon, this.fillColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Container(
        color: this.fillColor,
        margin: EdgeInsets.all(5),
      )),
      Icon(
        this.icon,
        color: iconColor,
      )
    ]);
  }
}
