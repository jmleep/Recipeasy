import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:my_recipes/widgets/photos/photo_preview_list.dart';

class AddEditRecipe2 extends StatefulWidget {
  final Recipe recipe;

  @override
  _AddEditRecipe2State createState() => _AddEditRecipe2State();

  AddEditRecipe2({this.recipe});
}

class _AddEditRecipe2State extends State<AddEditRecipe2> {
  List<RecipePhoto> _tempRecipePhotos = new List<RecipePhoto>();
  final _picker = ImagePicker();
  var _activePhoto = 0;

  void getRecipeImages() async {
    if (widget.recipe != null) {
      RecipeDatabaseManager.getImages(widget.recipe.id)
          .then((value) => _tempRecipePhotos = value);
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

  swipeActivePhoto(DragEndDetails details) {
    if (details.primaryVelocity < 0) {
      setActivePhoto(_activePhoto + 1);
    } else {
      setActivePhoto(_activePhoto - 1);
    }
  }

  setActivePhoto(int index) {
    if (index < 0 || index >= _tempRecipePhotos.length) {
      return;
    }

    setState(() {
      _activePhoto = index;
    });
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
              ActivePhoto(
                  tempRecipePhotos: _tempRecipePhotos,
                  activePhoto: _activePhoto,
                  addImageToTempListOfPhotos: addImageToTempListOfPhotos,
                  swipeActivePhoto: swipeActivePhoto),
              PhotoPreviewList(
                  tempRecipePhotos: _tempRecipePhotos,
                  setActivePhoto: setActivePhoto,
                  activePhoto: _activePhoto),
            ],
          ),
        ),
      ),
    );
  }
}
