import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../buttons/button_recipeasy.dart';

class KeepEditingDialog extends StatelessWidget {
  final String recipeName;
  final ValueSetter<bool> saveRecipe;

  KeepEditingDialog({this.recipeName, this.saveRecipe}) : super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text('Leave $recipeName without saving?'),
      content: new Text('You have unsaved changes.'),
      actions: <Widget>[
        RoundedButton(
          buttonText: 'Cancel',
          onPressed: () => Navigator.of(context).pop(false),
          textColor: Colors.grey[900],
          borderColor: Colors.grey[900],
          fillColor: Colors.grey[300],
        ),
        RoundedButton(
          buttonText: 'Leave',
          onPressed: () => Navigator.of(context).pop(true),
          borderColor: Colors.red[700],
          fillColor: Colors.red[700],
          textColor: Colors.white,
        ),
        RoundedButton(
          buttonText: 'Save and Leave',
          onPressed: () {
            saveRecipe(true);
          },
          borderColor: Theme.of(context).colorScheme.primary,
          fillColor: Theme.of(context).colorScheme.primary,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
