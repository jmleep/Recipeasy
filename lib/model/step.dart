import 'package:my_recipes/model/recipe_attribute.dart';

class Step extends RecipeAttribute {
  Step({int id, int recipeId, String value})
      : super(id: id, recipeId: recipeId, value: value);
}