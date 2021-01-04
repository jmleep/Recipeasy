import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/button_primary_mini.dart';

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

  Widget getPhotoList() {
    return ConstrainedBox(
      constraints: new BoxConstraints(minHeight: 300, maxHeight: 300),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _tempRecipePhotos.length,
        itemBuilder: (context, index) {
          File image = new File(_tempRecipePhotos[index].value);
          return Image.file(
            image,
            height: 300,
            width: 150,
          );
        },
      ),
    );
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
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          getPhotoList(),
          // Container(
          //   width: 100,
          //   height: 150,
          //   color: Colors.grey,
          //   child: Icon(
          //     Icons.add_a_photo,
          //     color: Colors.white,
          //   ),
          // ),

          MiniPrimaryButton(
              buttonText: 'Add Image',
              onButtonPress: addImageToTempListOfPhotos),
        ],
      ),
    );
  }
}
