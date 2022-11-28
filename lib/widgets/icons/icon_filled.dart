import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilledIcon extends StatelessWidget {
  final IconData icon;
  final Color fillColor;
  final Color iconColor;

  FilledIcon(
      {required this.icon, required this.fillColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Container(
        color: fillColor,
        margin: EdgeInsets.all(5),
      )),
      Icon(
        icon,
        color: iconColor,
      )
    ]);
  }
}
