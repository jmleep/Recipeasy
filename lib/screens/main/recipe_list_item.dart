import 'dart:io';

import 'package:flutter/material.dart';

Future<File> _getFile(String filename) async {
  File f = new File(filename);
  return f;
}

class RecipeListItem extends StatelessWidget {
  final String recipeName;
  final String recipeImagePath;
  final Color recipeColor;

  const RecipeListItem(
      {Key key, this.recipeName, this.recipeImagePath, this.recipeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: recipeColor,
      child: Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: _getFile(recipeImagePath),
                  builder: (BuildContext context,
                      AsyncSnapshot<File> snapshot) {
                    return snapshot.data != null
                        ? CircleAvatar(
                      radius: 45,
                      backgroundImage:
                      FileImage(snapshot.data),
                    )
                        : CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.photo),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    );
                  }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            '$recipeName',
            style: TextStyle(
                color: recipeColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
                fontSize: 20),
          ),
        ),
      ]),
    );
  }
}