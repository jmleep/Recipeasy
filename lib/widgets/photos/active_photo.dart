import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_photo.dart';
import 'package:my_recipes/widgets/buttons/button_recipeasy.dart';

class ActivePhoto extends StatelessWidget {
  final List<RecipePhoto> recipePhotos;
  final int activePhoto;
  final Function addImageToTempListOfPhotos;
  final Function swipeActivePhoto;
  final Function deletePhoto;
  final Function setPrimaryPhoto;

  ActivePhoto(
      {this.recipePhotos,
      this.activePhoto,
      this.addImageToTempListOfPhotos,
      this.swipeActivePhoto,
      this.deletePhoto,
      this.setPrimaryPhoto});

  Widget getPrimaryPhotoButton() {
    if (this.setPrimaryPhoto != null && recipePhotos.length > 1) {
      var button;
      RecipePhoto currentPhoto = recipePhotos[activePhoto];

      if (currentPhoto.isPrimary) {
        button = RoundedButton(
          buttonText: 'Set cover photo',
          borderColor: Colors.grey[700],
          fillColor: Colors.grey[400],
          textColor: Colors.grey[700],
          onPressed: () => {},
        );
      } else {
        button = RoundedButton(
          buttonText: 'Set cover photo',
          borderColor: Colors.blue,
          fillColor: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            setPrimaryPhoto();
          },
        );
      }

      return Positioned(bottom: 10, left: 10, child: button);
    }
    return SizedBox.shrink();
  }

  Widget getDeleteButton() {
    if (this.deletePhoto != null) {
      return Positioned(
          bottom: 10,
          right: 10,
          child: RoundedButton(
            buttonText: 'Delete photo',
            borderColor: Colors.red,
            fillColor: Colors.red,
            textColor: Colors.white,
            onPressed: () {
              deletePhoto(activePhoto);
            },
          ));
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (recipePhotos.length > 0) {
      container = Container(
          height: 500,
          child: Stack(
            children: [
              Center(
                  child: Image.memory(recipePhotos[activePhoto]
                      .image)), // Image.file(new File(recipePhotos[activePhoto].value))),
              getPrimaryPhotoButton(),
              getDeleteButton()
            ],
          ));
    } else {
      return Container();
    }

    return Container(
        child: GestureDetector(
      onHorizontalDragEnd: (details) => swipeActivePhoto(details, recipePhotos),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: container,
      ),
    ));
  }
}
