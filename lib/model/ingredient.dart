import 'package:my_recipes/model/recipe_attribute.dart';

class Ingredient extends RecipeAttribute {
  Ingredient({int id, int recipeId, String value})
      : super(id: id, recipeId: recipeId, value: value);
}