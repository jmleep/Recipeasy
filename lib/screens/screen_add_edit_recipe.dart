import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/dialogs/dialog_keep_editing.dart';
import 'package:my_recipes/widgets/inputs/name_text_form_field.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/photos/photo_preview_list.dart';
import 'common/view_add_edit_recipe.dart';

class AddEditRecipeScreen extends ViewAddEditRecipe {
  final Recipe recipe;

  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();

  AddEditRecipeScreen({this.recipe});
}

class _AddEditRecipeState extends ViewAddEditRecipeState<AddEditRecipeScreen> {
  List<RecipePhoto> _tempRecipePhotos = [];
  List<RecipePhoto> _tempRecipePhotosToDelete = [];
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _recipeNameController = TextEditingController();
  var _hasChangeBeenMade = false;

  setupRecipeData() async {
    if (widget.recipe != null) {
      setState(() {
        _recipeNameController = TextEditingController(text: widget.recipe.name);
      });

      var images = await RecipePhotoDatabaseManager.getImages(widget.recipe.id);

      setState(() {
        _tempRecipePhotos = images;
      });
    }

    setState(() {
      _recipeNameController.addListener(() {
        if (widget.recipe != null &&
            _recipeNameController.text != widget.recipe.name) {
          setState(() {
            _hasChangeBeenMade = true;
          });
        } else if (widget.recipe == null && _recipeNameController.text != '') {
          setState(() {
            _hasChangeBeenMade = true;
          });
        }
      });
    });
  }

  deletePhoto(int index) {
    var tempActivePhoto = 0;

    if (index > 0) {
      if (_tempRecipePhotos.length > 2) {
        tempActivePhoto = activePhoto - 1;
      }

      setState(() {
        _tempRecipePhotos[tempActivePhoto].isPrimary = true;
      });
    }

    setState(() {
      activePhoto = tempActivePhoto;
      _hasChangeBeenMade = true;
      _tempRecipePhotosToDelete.add(_tempRecipePhotos[index]);
      _tempRecipePhotos.removeAt(index);
    });
  }

  setPrimaryPhoto() {
    int oldPrimary =
        _tempRecipePhotos.indexWhere((element) => element.isPrimary);

    setState(() {
      _hasChangeBeenMade = true;
      _tempRecipePhotos[oldPrimary].isPrimary = false;
      _tempRecipePhotos[activePhoto].isPrimary = true;
    });
  }

  Future addImageToTempListOfPhotos() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      var imageBytes = await pickedFile.readAsBytes();

      var photo = new RecipePhoto(
          image: imageBytes, isPrimary: _tempRecipePhotos.length == 0);

      setState(() {
        _hasChangeBeenMade = true;
        _tempRecipePhotos.add(photo);
        activePhoto = _tempRecipePhotos.length - 1;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        previewScrollController.animateTo(
          previewScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future saveRecipe(bool isFromBackAttempt) async {
    if (_formKey.currentState.validate()) {
      if (_tempRecipePhotos.length > 0) {
        Recipe recipe;

        if (widget.recipe != null) {
          recipe = widget.recipe;
          recipe.name = _recipeNameController.text;
          recipe.photos = _tempRecipePhotos;
        } else {
          recipe = new Recipe(
              name: _recipeNameController.text, photos: _tempRecipePhotos);
        }

        var recipeId = await RecipeDatabaseManager.upsertRecipe(recipe);

        await RecipePhotoDatabaseManager.savePhotos(
            recipeId, _tempRecipePhotos);

        RecipePhotoDatabaseManager.deletePhotos(_tempRecipePhotosToDelete);

        HapticFeedback.heavyImpact();

        Navigator.of(context).pop(true);
      } else {
        if (isFromBackAttempt) {
          Navigator.of(context).pop(false);
        }

        final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red[700],
            content: Container(
                height: 15,
                child: Center(
                  child: Text(
                    'Please add a photo in order to create your recipe!',
                    style: TextStyle(
                      color: Colors.white,
                    ), // fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  List<AppBarAction> getAppBarActions() {
    return [
      new AppBarAction(
          Icon(
            Icons.add_a_photo,
            color: Theme.of(context).colorScheme.primary,
          ),
          addImageToTempListOfPhotos),
      new AppBarAction(
          Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.primary,
          ),
          () => saveRecipe(false))
    ];
  }

  String getTitle() {
    if (widget.recipe != null) {
      return "Edit Recipe";
    }
    return "Add Recipe";
  }

  Future<bool> onPressBackButton() async {
    String recipeName = 'this recipe';

    if (widget.recipe != null) {
      recipeName = widget.recipe.name;
    }

    if (_hasChangeBeenMade) {
      return (await showDialog(
            context: context,
            builder: (context) => KeepEditingDialog(
                recipeName: recipeName, saveRecipe: saveRecipe),
          )) ??
          false;
    }

    Navigator.pop(context, true);
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();

    setupRecipeData();
  }

  @override
  void dispose() {
    super.dispose();
    _recipeNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onPressBackButton,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: RecipeAppBar(
            title: getTitle(),
            actions: getAppBarActions(),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    NameTextFormField(
                      formKey: _formKey,
                      recipeNameController: _recipeNameController,
                    ),
                    ActivePhoto(
                        recipePhotos: _tempRecipePhotos,
                        activePhoto: activePhoto,
                        addImageToTempListOfPhotos: addImageToTempListOfPhotos,
                        swipeActivePhoto: swipeActivePhoto,
                        deletePhoto: deletePhoto,
                        setPrimaryPhoto: setPrimaryPhoto),
                    PhotoPreviewList(
                        scrollController: previewScrollController,
                        recipePhotos: _tempRecipePhotos,
                        setActivePhoto: setActivePhoto,
                        activePhoto: activePhoto),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
