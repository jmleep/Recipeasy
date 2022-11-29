import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/ingredient.dart';
import '../../../data/model/recipe.dart';
import '../../../data/model/recipe_photo.dart';
import '../../../data/repository/recipe_photo_repository.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../add_edit_recipe/screen_add_edit_recipe.dart';

class ViewRecipeViewModel extends ChangeNotifier {
  late Recipe recipe;
  List<RecipePhoto> recipeImages = [];
  List<Ingredient> recipeIngredients = [];
  bool isLoading = true;

  init(Recipe r) {
    recipeIngredients = [];
    recipeImages = [];
    recipe = r;
    isLoading = true;

    getRecipeData();
  }

  getRecipeData() async {
    var imageFuture = RecipePhotoDatabaseManager.getImages(recipe.id);
    var ingredientFuture = RecipeDatabaseManager.getIngredients(recipe.id);

    var results = await Future.wait([imageFuture, ingredientFuture]);

    recipeImages.addAll(results[0] as List<RecipePhoto>);
    recipeIngredients.addAll(results[1] as List<Ingredient>);
    isLoading = false;
    notifyListeners();
  }

  editRecipe(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditRecipeScreen(
                recipe: recipe,
              )),
    );

    Recipe updatedRecipe = await RecipeDatabaseManager.getRecipe(recipe.id!);

    recipe = updatedRecipe;
    recipeImages = [];
    recipeIngredients = [];

    notifyListeners();
    getRecipeData();
  }
}
