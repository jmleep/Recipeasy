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

                Widget response = imageWidget;

                if (index == this.activePhoto) {
                  response = Stack(
                    children: <Widget>[
                      imageWidget,
                      Positioned(
                          bottom: 5,
                          right: 15,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.deepOrange,
                          )),
                    ],
                  );
                }

                return GestureDetector(
                    onTap: () => setActivePhoto(index), child: response);
              },
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }
}
