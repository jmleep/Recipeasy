import 'package:flutter/material.dart';

class MiniPrimaryButton extends StatelessWidget {
  final Function onButtonPress; 
  final IconData icon;

  MiniPrimaryButton({this.onButtonPress, this.icon});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Theme.of(context).primaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Add Ingredient',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        onPressed: onButtonPress,
      ),
    );
  }
}