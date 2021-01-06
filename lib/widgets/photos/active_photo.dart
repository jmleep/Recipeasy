import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/buttons/rounded_button.dart';

class ActivePhoto extends StatelessWidget {
  final List<RecipePhoto> tempRecipePhotos;
  final int activePhoto;
  final Function addImageToTempListOfPhotos;
  final Function swipeActivePhoto;
  final Function deletePhoto;
  final Function setPrimaryPhoto;

  ActivePhoto(
      {this.tempRecipePhotos,
      this.activePhoto,
      this.addImageToTempListOfPhotos,
      this.swipeActivePhoto,
      this.deletePhoto,
      this.setPrimaryPhoto});

  Widget getPrimaryPhotoButton(RecipePhoto currentPhoto) {
    if (currentPhoto.isPrimary) {
      return RoundedButton(
        buttonText: 'Make Primary Photo',
        borderColor: Colors.blue,
        fillColor: Colors.white70,
        textColor: Colors.black,
        onPressed: () {
          print("already primary");
        },
      );
    } else {
      return RoundedButton(
        buttonText: 'Make Primary Photo',
        borderColor: Colors.blue,
        fillColor: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          setPrimaryPhoto();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (tempRecipePhotos.length > 0) {
      container = Container(
          constraints: BoxConstraints.expand(),
          child: Stack(
            children: [
              Center(
                  child: Image.file(
                      new File(tempRecipePhotos[activePhoto].value))),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: getPrimaryPhotoButton(tempRecipePhotos[activePhoto])),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: RoundedButton(
                    buttonText: 'Delete Photo',
                    borderColor: Colors.red,
                    fillColor: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      deletePhoto(activePhoto);
                    },
                  )),
            ],
          ));
    } else {
      return Expanded(
        child: Container(
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
