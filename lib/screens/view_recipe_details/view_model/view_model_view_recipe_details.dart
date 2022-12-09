import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_step.dart';

import '../../../data/model/recipe_ingredient.dart';
import '../../../data/model/recipe.dart';
import '../../../data/model/recipe_photo.dart';
import '../../../data/model/recipe_tag.dart';
import '../../../data/repository/recipe_photo_repository.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../add_edit_recipe/screen_add_edit_recipe.dart';

class ViewRecipeViewModel extends ChangeNotifier {
  late Recipe recipe;
  List<RecipePhoto> recipeImages = [];
  List<RecipeIngredient> recipeIngredients = [];
  List<RecipeStep> recipeSteps = [];
  List<RecipeTag> recipeTags = [];
  bool isLoading = true;

  init(Recipe r) {
    recipeIngredients = [];
    recipeImages = [];
    recipeSteps = [];
    recipeTags = [];
    recipe = r;
    isLoading = true;

    getRecipeData();
  }

  getRecipeData() async {
    var imageFuture = RecipePhotoDatabaseManager.getImages(recipe.id);
    var ingredientFuture = RecipeDatabaseManager.getIngredients(recipe.id);
    var stepsFuture = RecipeDatabaseManager.getSteps(recipe.id);
    var tagsFuture = RecipeDatabaseManager.getTags(recipe.id);

    var results = await Future.wait(
        [imageFuture, ingredientFuture, stepsFuture, tagsFuture]);

    recipeImages.addAll(results[0] as List<RecipePhoto>);
    recipeIngredients.addAll(results[1] as List<RecipeIngredient>);
    recipeSteps.addAll(results[2] as List<RecipeStep>);
    recipeTags.addAll(results[3] as List<RecipeTag>);

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
    recipeSteps = [];
    recipeTags = [];

    notifyListeners();
    getRecipeData();
  }
}
