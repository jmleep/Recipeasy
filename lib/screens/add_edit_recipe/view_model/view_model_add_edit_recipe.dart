import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/model/ingredient.dart';
import '../../../data/model/recipe.dart';
import '../../../data/model/recipe_photo.dart';
import '../../../data/repository/recipe_photo_repository.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../../widgets/dialogs/dialog_keep_editing.dart';

class AddEditRecipeViewModel extends ChangeNotifier {
  late Recipe? recipe;
  List<RecipePhoto> tempRecipePhotos = [];
  List<RecipePhoto> tempRecipePhotosToDelete = [];
  List<TextEditingController> recipeIngredientControllers = [];
  List<Ingredient> recipeIngredients = [];
  List<Ingredient> recipeIngredientsToDelete = [];
  ScrollController scrollController = ScrollController();
  TextEditingController recipeNameController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  bool hasChangeBeenMade = false;
  var formKey = GlobalKey<FormState>();

  @mustCallSuper
  dispose() {
    recipeNameController.dispose();
    scrollController.dispose();
    for (final controller in recipeIngredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  init(Recipe? r) {
    recipe = r;
    tempRecipePhotos = [];
    tempRecipePhotosToDelete = [];
    recipeIngredientControllers = [];
    recipeIngredients = [];
    scrollController = ScrollController();
    recipeNameController = TextEditingController();
    hasChangeBeenMade = false;

    getRecipeData();
  }

  getRecipeData() async {
    if (recipe != null) {
      recipeNameController = TextEditingController(text: recipe!.name);

      var imagesFuture = RecipePhotoDatabaseManager.getImages(recipe!.id!);
      var ingredientsFuture = RecipeDatabaseManager.getIngredients(recipe!.id!);

      var results = await Future.wait([imagesFuture, ingredientsFuture]);

      tempRecipePhotos.addAll(results[0] as List<RecipePhoto>);
      recipeIngredients.addAll(results[1] as List<Ingredient>);
    }

    recipeNameController.addListener(() {
      if (recipe != null && recipeNameController.text != recipe!.name) {
        hasChangeBeenMade = true;
      } else if (recipe == null && recipeNameController.text != '') {
        hasChangeBeenMade = true;
      }
    });
    notifyListeners();
  }

  String getTitle() {
    if (recipe != null) {
      return "Edit Recipe";
    }
    return "Add Recipe";
  }

  deletePhoto(int? index, int activePhoto) {
    var tempActivePhoto = 0;

    if (index != null) {
      if (index > 0) {
        if (tempRecipePhotos.length > 2) {
          tempActivePhoto = activePhoto - 1;
        }

        tempRecipePhotos[tempActivePhoto].isPrimary = true;
      }

      activePhoto = tempActivePhoto;
      hasChangeBeenMade = true;
      tempRecipePhotosToDelete.add(tempRecipePhotos[index]);
      tempRecipePhotos.removeAt(index);
      notifyListeners();
    }
  }

  setPrimaryPhoto(int activePhoto) {
    int oldPrimary =
        tempRecipePhotos.indexWhere((element) => element.isPrimary);

    hasChangeBeenMade = true;
    tempRecipePhotos[oldPrimary].isPrimary = false;
    tempRecipePhotos[activePhoto].isPrimary = true;
  }

  addIngredient(String text) {
    recipeIngredients.add(Ingredient(value: text));
    hasChangeBeenMade = true;

    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 10), curve: Curves.ease);
    notifyListeners();
  }

  removeIngredient(int index) {
    recipeIngredientsToDelete.add(recipeIngredients[index]);
    recipeIngredients.removeAt(index);
    notifyListeners();
  }

  updateIngredient(String text, Ingredient i) {
    var index = recipeIngredients.indexOf(i);
    var ingredient = recipeIngredients[index];

    recipeIngredients[index] = ingredient.copyWith(null, null, text);
    hasChangeBeenMade = true;
    notifyListeners();
  }

  Future addImageToTempListOfPhotos(ScrollController previewScrollController,
      Function(int, List<RecipePhoto>) setActivePhoto) async {
    final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      var imageBytes = await pickedFile.readAsBytes();

      var photo = new RecipePhoto(
          image: imageBytes, isPrimary: tempRecipePhotos.length == 0);

      hasChangeBeenMade = true;
      tempRecipePhotos.add(photo);
      setActivePhoto(tempRecipePhotos.length - 1, tempRecipePhotos);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        previewScrollController.animateTo(
          previewScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      notifyListeners();
    }
  }

  Future saveRecipe(BuildContext context) async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      Recipe editingRecipe;

      for (var i = 0; i < recipeIngredients.length; i += 1) {
        recipeIngredients[i].value = recipeIngredientControllers[i].value.text;
      }

      if (recipe != null) {
        editingRecipe = recipe!;
        editingRecipe.name = recipeNameController.text;
        editingRecipe.photos = tempRecipePhotos;
        editingRecipe.ingredients = recipeIngredients;
      } else {
        editingRecipe = new Recipe(
            name: recipeNameController.text,
            photos: tempRecipePhotos,
            ingredients: recipeIngredients);
      }

      RecipeDatabaseManager.deleteIngredients(recipeIngredientsToDelete);

      var recipeId = await RecipeDatabaseManager.upsertRecipe(editingRecipe);

      await RecipePhotoDatabaseManager.savePhotos(recipeId, tempRecipePhotos);

      RecipePhotoDatabaseManager.deletePhotos(tempRecipePhotosToDelete);

      HapticFeedback.heavyImpact();

      Navigator.of(context).pop(true);
    } //else {
    // if (isFromBackAttempt) {
    //   Navigator.of(context).pop(false);
    // }
    //
    // final snackBar = SnackBar(
    //     duration: Duration(seconds: 2),
    //     backgroundColor: Colors.red[700],
    //     content: Container(
    //         height: 15,
    //         child: Center(
    //           child: Text(
    //             'Please add a photo in order to create your recipe!',
    //             style: TextStyle(
    //               color: Colors.white,
    //             ), // fontSize: 20),
    //             textAlign: TextAlign.center,
    //           ),
    //         )));
    //
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }

  Future<bool> onPressBackButton(BuildContext context) async {
    String recipeName = 'this recipe';

    if (recipe != null) {
      recipeName = recipe!.name;
    }

    if (hasChangeBeenMade) {
      return (await showDialog(
            context: context,
            builder: (context) => KeepEditingDialog(
                recipeName: recipeName, saveRecipe: () => saveRecipe(context)),
          )) ??
          false;
    }

    Navigator.pop(context, true);
    return Future.value(false);
  }
}