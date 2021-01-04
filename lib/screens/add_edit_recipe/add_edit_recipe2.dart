import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/app_bar.dart';

class AddEditRecipe2 extends StatefulWidget {
  final Recipe recipe;

  @override
  _AddEditRecipe2State createState() => _AddEditRecipe2State();

  AddEditRecipe2({this.recipe});
}

class _AddEditRecipe2State extends State<AddEditRecipe2> {
  Future<List<RecipePhoto>> _recipeImages;
  List<RecipePhoto> _tempRecipePhotos = new List<RecipePhoto>();
  final _picker = ImagePicker();
  var activePhoto = 0;

  void getRecipeImages() async {
    if (widget.recipe != null) {
      _recipeImages = RecipeDatabaseManager.getImages(widget.recipe.id);
    }
  }

  Future addImageToTempListOfPhotos() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      RecipePhoto photo = new RecipePhoto(value: pickedFile.path);

      setState(() {
        _tempRecipePhotos.add(photo);
      });
      print(_tempRecipePhotos.length);
    }
  }

  Future saveTempListOfPhotos() async {
    print('saved');
  }

  List<AppBarAction> getAppBarActions() {
    return [
      new AppBarAction(
          Icon(
            Icons.add_a_photo,
            color: Theme.of(context).primaryColor,
          ),
          addImageToTempListOfPhotos),
      new AppBarAction(
          Icon(
            Icons.check,
            color: Theme.of(context).primaryColor,
          ),
          saveTempListOfPhotos)
    ];
  }

  Widget getPhotoList() {
    return ConstrainedBox(
      constraints: new BoxConstraints(minHeight: 100, maxHeight: 100),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _tempRecipePhotos.length,
        itemBuilder: (context, index) {
          File image = new File(_tempRecipePhotos[index].value);
          return GestureDetector(
            onTap: () => setActivePhoto(index),
            child: Image.file(
              image,
              height: 100,
              width: 75,
            ),
          );
        },
      ),
    );
  }

  swipeActivePhoto(DragEndDetails details) {
    if (details.primaryVelocity < 0) {
      setActivePhoto(activePhoto + 1);
    } else {
      setActivePhoto(activePhoto - 1);
    }
  }

  setActivePhoto(int index) {
    if (index < 0 || index >= _tempRecipePhotos.length) {
      return;
    }

    setState(() {
      activePhoto = index;
    });
  }

  Widget getActivePhoto() {
    var container;
    if (_tempRecipePhotos.length > 0) {
      container = Container(
          color: Colors.red,
          constraints: BoxConstraints.expand(),
          child: Image.file(new File(_tempRecipePhotos[activePhoto].value)));
    } else {
      container = Container(
        color: Colors.grey,
        constraints: BoxConstraints.expand(),
        child: Icon(
          Icons.add_a_photo,
          color: Colors.white,
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

  @override
  void initState() {
    super.initState();
    getRecipeImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RecipeAppBar(
        title: "Add Recipe",
        actions: getAppBarActions(),
      ),
      body: Container(
        color: Colors.greenAccent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getActivePhoto(),
              getPhotoList(),
            ],
          ),
        ),
      ),
    );
  }
}
