import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_step.dart';
import 'package:my_recipes/data/repository/recipe_repository_interface.dart';

import '../../../data/model/recipe_ingredient.dart';
import '../../../data/model/recipe.dart';
import '../../../data/model/recipe_photo.dart';
import '../../../data/model/recipe_tag.dart';
import '../../../data/repository/recipe_photo_repository.dart';
import '../../add_edit_recipe/screen_add_edit_recipe.dart';

class ViewRecipeViewModel extends ChangeNotifier {
  late Recipe recipe;
  late RecipeRepository repository;
  List<RecipePhoto> recipeImages = [];
  List<RecipeIngredient> recipeIngredients = [];
  List<RecipeStep> recipeSteps = [];
  List<RecipeTag> recipeTags = [];
  bool isLoading = true;

  init(Recipe r, RecipeRepository rep) {
    recipeIngredients = [];
    recipeImages = [];
    recipeSteps = [];
    recipeTags = [];
    recipe = r;
    repository = rep;
    isLoading = true;

    getRecipeData();
  }

  getRecipeData() async {
    var imageFuture = RecipePhotoDatabaseManager.getImages(recipe.id);
    var ingredientFuture = repository.getIngredients(recipe.id);
    var stepsFuture = repository.getSteps(recipe.id);
    var tagsFuture = repository.getTags(recipe.id);

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
                repository: repository,
              )),
    );

    Recipe updatedRecipe = await repository.getRecipe(recipe.id!);

    recipe = updatedRecipe;
    recipeImages = [];
    recipeIngredients = [];
    recipeSteps = [];
    recipeTags = [];

    notifyListeners();
    getRecipeData();
  }
}
