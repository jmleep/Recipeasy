import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/model/recipe_photo.dart';

class ActivePhoto extends StatelessWidget {
  final List<RecipePhoto> tempRecipePhotos;
  final int activePhoto;
  final Function addImageToTempListOfPhotos;
  final Function swipeActivePhoto;

  ActivePhoto(
      {this.tempRecipePhotos,
      this.activePhoto,
      this.addImageToTempListOfPhotos,
      this.swipeActivePhoto});

  @override
  Widget build(BuildContext context) {
    var container;
    if (tempRecipePhotos.length > 0) {
      container = Container(
          color: Colors.red,
          constraints: BoxConstraints.expand(),
          child: Image.file(new File(tempRecipePhotos[activePhoto].value)));
    } else {
      return Expanded(
        child: Container(
          color: Colors.purple,
          child: GestureDetector(
            onTap: () => addImageToTempListOfPhotos(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Click '),
                Icon(
                  Icons.add_a_photo,
                ),
                Text(' to add photos!')
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
        child: GestureDetector(
      onHorizontalDragEnd: (details) => swipeActivePhoto(details),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: container,
      ),
    ));
  }
}
