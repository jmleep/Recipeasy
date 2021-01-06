import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/rounded_button.dart';
import 'package:my_recipes/widgets/inputs/name_text_form_field.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:my_recipes/widgets/photos/photo_preview_list.dart';

class AddEditRecipe extends StatefulWidget {
  final Recipe recipe;

  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();

  AddEditRecipe({this.recipe});
}

class _AddEditRecipeState extends State<AddEditRecipe> {
  List<RecipePhoto> _tempRecipePhotos = new List<RecipePhoto>();
  List<RecipePhoto> _tempRecipePhotosToDelete = new List<RecipePhoto>();
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _previewScrollController;
  var _recipeNameController = TextEditingController();
  var _activePhoto = 0;
  var _hasChangeBeenMade = false;

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
    var activePhoto = 0;

    if (index != 0) {
      if (_tempRecipePhotos.length > 2) {
        activePhoto = _activePhoto - 1;
      } else {
        activePhoto = 0;
      }
    }

    setState(() {
      _hasChangeBeenMade = true;
      _tempRecipePhotosToDelete.add(_tempRecipePhotos[index]);
      _activePhoto = activePhoto;
      _tempRecipePhotos.removeAt(index);
    });
  }

  setPrimaryPhoto() {
    int oldPrimary =
        _tempRecipePhotos.indexWhere((element) => element.isPrimary);

    setState(() {
      _hasChangeBeenMade = true;
      _tempRecipePhotos[oldPrimary].isPrimary = false;
      _tempRecipePhotos[_activePhoto].isPrimary = true;
    });
  }

  Future addImageToTempListOfPhotos() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      RecipePhoto photo;
      if (_tempRecipePhotos.length == 0) {
        photo = new RecipePhoto(value: pickedFile.path, isPrimary: true);
      } else {
        photo = new RecipePhoto(value: pickedFile.path);
      }

      setState(() {
        _hasChangeBeenMade = true;
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

        RecipePhotoDatabaseManager.deletePhotos(_tempRecipePhotosToDelete);

        await RecipeDatabaseManager.upsertRecipe(recipe);

        HapticFeedback.heavyImpact();

        Navigator.of(context).pop(true);
      } else {
        if (isFromBackAttempt) {
          Navigator.of(context).pop(false);
        }

        final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red[900],
            content: Container(
                height: 100,
                child: Center(
                  child: Text(
                    'Please add a photo in order to create your recipe!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )));

        // Find the Scaffold in the widget tree and use it to show a SnackBar.
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
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
          () => saveRecipe(false))
    ];
  }

  triggerScrollAnimation(double position) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _previewScrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  swipeActivePhoto(DragEndDetails details) {
    HapticFeedback.selectionClick();

    final double photoWidth = 75.0;
    final double separatorWidth = 10.0;
    final double totalWidth = photoWidth + separatorWidth;

    if (details.primaryVelocity < 0) {
      if (_activePhoto > 2 ||
          _previewScrollController.position.pixels !=
              _previewScrollController.position.minScrollExtent) {
        triggerScrollAnimation((_activePhoto - 1) * totalWidth);
      }

      setActivePhoto(_activePhoto + 1);
    } else {
      triggerScrollAnimation((_activePhoto - 2) * totalWidth);

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

  Future<bool> onPressBackButton() async {
    String recipeName = 'this recipe';

    if (widget.recipe != null) {
      recipeName = widget.recipe.name;
    }

    print(_hasChangeBeenMade);
    if (_hasChangeBeenMade) {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Leave $recipeName without saving?'),
              content: new Text('You have unsaved changes.'),
              actions: <Widget>[
                RoundedButton(
                    buttonText: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(false),
                    textColor: Colors.white,
                    borderColor: Colors.white38),
                RoundedButton(
                  buttonText: 'Leave',
                  onPressed: () => Navigator.of(context).pop(true),
                  borderColor: Colors.red,
                  fillColor: Colors.red[200],
                  textColor: Colors.black,
                ),
                RoundedButton(
                  buttonText: 'Save and Leave',
                  onPressed: () {
                    saveRecipe(true);
                  },
                  borderColor: Colors.white,
                  fillColor: Colors.green,
                  textColor: Colors.white,
                ),
              ],
            ),
          )) ??
          false;
    }

    Navigator.pop(context, true);
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    _previewScrollController = new ScrollController();

    setupRecipeData();
  }

  @override
  void dispose() {
    super.dispose();
    _previewScrollController.dispose();
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
        body: Container(
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
                    tempRecipePhotos: _tempRecipePhotos,
                    activePhoto: _activePhoto,
                    addImageToTempListOfPhotos: addImageToTempListOfPhotos,
                    swipeActivePhoto: swipeActivePhoto,
                    deletePhoto: deletePhoto,
                    setPrimaryPhoto: setPrimaryPhoto),
                PhotoPreviewList(
                    scrollController: _previewScrollController,
                    tempRecipePhotos: _tempRecipePhotos,
                    setActivePhoto: setActivePhoto,
                    activePhoto: _activePhoto),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
