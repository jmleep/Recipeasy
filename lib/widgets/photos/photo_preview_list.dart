import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/model/recipe_photo.dart';

class PhotoPreviewList extends StatelessWidget {
  final ScrollController scrollController;
  final List<RecipePhoto> tempRecipePhotos;
  final Function setActivePhoto;
  final int activePhoto;

  PhotoPreviewList(
      {this.scrollController,
      this.tempRecipePhotos,
      this.setActivePhoto,
      this.activePhoto});

  @override
  Widget build(BuildContext context) {
    if (this.tempRecipePhotos.length > 0) {
      return Container(
        width: double.infinity,
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: new BoxConstraints(minHeight: 100, maxHeight: 100),
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: tempRecipePhotos.length,
              itemBuilder: (context, index) {
                File imageFile = new File(tempRecipePhotos[index].value);
                Widget imageWidget = Image.file(
                  imageFile,
                  height: 100,
                  width: 75,
                );

                List<Widget> stackContents = List<Widget>();
                stackContents.add(imageWidget);

                if (index == this.activePhoto) {
                  stackContents.add(Container(
                      width: 75,
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(width: 5, color: Colors.orange),
                      ))));
                }

                if (tempRecipePhotos[index].isPrimary) {
                  stackContents.add(Positioned(
                      top: 0,
                      right: 5,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blueAccent,
                      )));
                }

                return GestureDetector(
                    onTap: () => setActivePhoto(index),
                    child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[...stackContents]));
              },
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }
}
