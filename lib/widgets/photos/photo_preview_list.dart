import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/model/recipe_photo.dart';

const miniPhotoWidth = 75.0;
const miniPhotoHeight = 100.0;

class PhotoPreviewList extends StatelessWidget {
  final ScrollController scrollController;
  final List<RecipePhoto> recipePhotos;
  final Function setActivePhoto;
  final int activePhoto;

  PhotoPreviewList(
      {this.scrollController,
      this.recipePhotos,
      this.setActivePhoto,
      this.activePhoto});

  @override
  Widget build(BuildContext context) {
    if (this.recipePhotos.length > 0) {
      return Container(
        width: double.infinity,
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: new BoxConstraints(minHeight: miniPhotoHeight, maxHeight: miniPhotoHeight),
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: recipePhotos.length,
              itemBuilder: (context, index) {

                Widget imageWidget = Image.memory(
                  recipePhotos[index].image,
                  height: 100,
                  width: 75,
                );

                List<Widget> stackContents = [];
                stackContents.add(imageWidget);

                if (index == activePhoto) {
                  stackContents.add(Container(
                      width: miniPhotoWidth,
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(width: 5, color: Theme.of(context).accentColor),
                      ))));
                }

                if (recipePhotos[index].isPrimary) {
                  stackContents.add(Positioned(
                      top: 0,
                      right: 5,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blueAccent,
                      )));
                }

                return GestureDetector(
                    onTap: () {
                      setActivePhoto(index, recipePhotos);
                    },
                    child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[...stackContents]));
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10,
                );
              },
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }
}
