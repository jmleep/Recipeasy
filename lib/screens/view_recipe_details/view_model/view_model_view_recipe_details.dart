import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_step.dart';

import '../../../data/model/recipe_ingredient.dart';
import '../../../data/model/recipe.dart';
import '../../../data/model/recipe_photo.dart';
import '../../../data/repository/recipe_photo_repository.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../add_edit_recipe/screen_add_edit_recipe.dart';

class ViewRecipeViewModel extends ChangeNotifier {
  late Recipe recipe;
  List<RecipePhoto> recipeImages = [];
  List<RecipeIngredient> recipeIngredients = [];
  List<RecipeStep> recipeSteps = [];
  bool isLoading = true;

  init(Recipe r) {
    recipeIngredients = [];
    recipeImages = [];
    recipeSteps = [];
    recipe = r;
    isLoading = true;

    getRecipeData();
  }

  getRecipeData() async {
    var imageFuture = RecipePhotoDatabaseManager.getImages(recipe.id);
    var ingredientFuture = RecipeDatabaseManager.getIngredients(recipe.id);
    var stepsFuture = RecipeDatabaseManager.getSteps(recipe.id);

    var results =
        await Future.wait([imageFuture, ingredientFuture, stepsFuture]);

    recipeImages.addAll(results[0] as List<RecipePhoto>);
    recipeIngredients.addAll(results[1] as List<RecipeIngredient>);
    recipeSteps.addAll(results[2] as List<RecipeStep>);
    recipeSteps.add(RecipeStep(
        id: 0,
        recipeId: 0,
        value:
            'Do the thingasdfasdfasdfasdfasdfasdflkjsdf;lkajs;dlfkja;sldfkja;lskjdf;alskjdf;laksjdflakfkadfjk;lsdjkfa;lsdkjf;lasjk;kjf;asf'));
    recipeSteps.add(RecipeStep(id: 0, recipeId: 0, value: 'Cook 30 minutes'));
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
