import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/util/widget_styles.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _previewScrollController = new ScrollController();
  var _recipeNameController = TextEditingController();
  var _activePhoto = 0;

  setupRecipeData() async {
    if (widget.recipe != null) {
      setState(() {
        _recipeNameController = TextEditingController(text: widget.recipe.name);
      });

      RecipePhotoDatabaseManager.getImages(widget.recipe.id).then((value) {
        setState(() {
          _tempRecipePhotos = value;
        });
      });
    }
  }

  deletePhoto(int index) {
    var activePhoto = 0;

    if (index != 0) {
      if (_tempRecipePhotos.length > 2) {
        activePhoto = _activePhoto - 1;
      } else {
        activePhoto = 0;
      }
    }

    setState(() {
      _activePhoto = activePhoto;
      _tempRecipePhotos.removeAt(index);
    });
  }

  Future addImageToTempListOfPhotos() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      RecipePhoto photo = new RecipePhoto(value: pickedFile.path);

      setState(() {
        _tempRecipePhotos.add(photo);
        _activePhoto = _tempRecipePhotos.length - 1;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _previewScrollController.animateTo(
          _previewScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future saveTempListOfPhotos() async {
    if (_formKey.currentState.validate()) {
      Recipe recipe;

      if (widget.recipe != null) {
        recipe = widget.recipe;
        recipe.name = _recipeNameController.text;
        recipe.photos = _tempRecipePhotos;
      } else {
        recipe = new Recipe(
            name: _recipeNameController.text, photos: _tempRecipePhotos);
      }

      await RecipeDatabaseManager.upsertRecipe(recipe);

      Navigator.pop(context);
    }
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
    var scrollPosition;

    if (details.primaryVelocity < 0) {
      if (_activePhoto > 2 || _previewScrollController.position.pixels != _previewScrollController.position.minScrollExtent) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _previewScrollController.animateTo(
            (_activePhoto - 2) * 75.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }

      setActivePhoto(_activePhoto + 1);
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _previewScrollController.animateTo(
          (_activePhoto - 2) * 75.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

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

  String getTitle() {
    if (widget.recipe != null) {
      return "Edit Recipe";
    }
    return "Add Recipe";
  }

  @override
  void initState() {
    super.initState();
    setupRecipeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RecipeAppBar(
        title: getTitle(),
        actions: getAppBarActions(),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _recipeNameController,
                    decoration: ReusableStyleWidget.inputDecoration(
                        context, 'Recipe Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please a recipe name!';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ActivePhoto(
                tempRecipePhotos: _tempRecipePhotos,
                activePhoto: _activePhoto,
                addImageToTempListOfPhotos: addImageToTempListOfPhotos,
                swipeActivePhoto: swipeActivePhoto,
                deletePhoto: deletePhoto,
              ),
              PhotoPreviewList(
                  scrollController: _previewScrollController,
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
