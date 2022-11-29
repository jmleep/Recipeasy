import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_photo.dart';
import 'package:my_recipes/widgets/icons/icon_filled.dart';

const miniPhotoWidth = 75.0;
const miniPhotoHeight = 100.0;

class PhotoPreviewList extends StatelessWidget {
  final ScrollController scrollController;
  final List<RecipePhoto> recipePhotos;
  final Function setActivePhoto;
  final int? activePhoto;
  final Function? addPhoto;

  PhotoPreviewList(
      {required this.scrollController,
      required this.recipePhotos,
      required this.setActivePhoto,
      this.activePhoto,
      this.addPhoto});

  @override
  Widget build(BuildContext context) {
    var itemCount = recipePhotos.length;
    if (addPhoto != null) {
      itemCount += 1;
    }

    if (recipePhotos.length == 0 && addPhoto == null) {
      return SizedBox.shrink();
    }

    if (recipePhotos.length <= 5) {
      return Container(
        width: double.infinity,
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: new BoxConstraints(
                minHeight: miniPhotoHeight, maxHeight: miniPhotoHeight),
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (addPhoto != null &&
                    index > recipePhotos.length - 1 &&
                    recipePhotos.length < 5) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary)),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => {addPhoto!()},
                    ),
                  );
                }

                if (index < recipePhotos.length) {
                  Widget imageWidget = Image.memory(
                    recipePhotos[index].image!,
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
                          bottom: BorderSide(
                              width: 5,
                              color: Theme.of(context).colorScheme.secondary),
                        ))));
                  }

                  if (recipePhotos[index].isPrimary) {
                    stackContents.add(Positioned(
                        top: 0,
                        right: 5,
                        child: FilledIcon(
                            icon: Icons.check_circle,
                            fillColor: Colors.white,
                            iconColor: Colors.blueAccent)));
                  }

                  return GestureDetector(
                      onTap: () {
                        setActivePhoto(index, recipePhotos);
                      },
                      child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[...stackContents]));
                }
                return SizedBox.shrink();
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
