import 'package:my_recipes/data/model/recipe_attribute.dart';

class RecipeStep extends RecipeAttribute {
  RecipeStep({required int id, required int? recipeId, String? value})
      : super(id: id, recipeId: recipeId, value: value);
}
