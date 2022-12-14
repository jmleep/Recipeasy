import 'package:my_recipes/data/model/recipe_ingredient.dart';

import '../model/recipe.dart';
import '../model/recipe_step.dart';
import '../model/recipe_tag.dart';

abstract class RecipeRepository {
  Future<int> upsertRecipe(Recipe recipe);
  Future<int> deleteRecipe(Recipe recipe);
  Future<Recipe> getRecipe(int recipeId);
  Future<List<Recipe>> getAllRecipes();
  Future<List<RecipeIngredient>> getIngredients(int? recipeId);
  Future<void> deleteIngredients(List<RecipeIngredient> ingredients);
  Future<List<RecipeStep>> getSteps(int? recipeId);
  Future<void> deleteSteps(List<RecipeStep> steps);
  Future<List<RecipeTag>> getTags(int? recipeId);
  Future<List<RecipeTag>> getAllTags();
  Future<List<Recipe>> searchRecipes(String text);
}
