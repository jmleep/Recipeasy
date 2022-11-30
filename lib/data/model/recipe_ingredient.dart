import 'package:my_recipes/data/model/recipe_attribute.dart';

class RecipeIngredient extends RecipeAttribute {
  RecipeIngredient({int? id, int? recipeId, String? value})
      : super(id: id, recipeId: recipeId, value: value);
}
