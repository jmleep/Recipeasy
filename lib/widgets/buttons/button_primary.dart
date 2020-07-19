import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onButtonPress;
  final IconData icon;
  final String text;

  PrimaryButton({this.onButtonPress, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Theme.of(context).primaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        ),
        onPressed: onButtonPress,
      ),
    );
  }
}
