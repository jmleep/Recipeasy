import 'package:my_recipes/data/model/recipe_attribute.dart';

class Step extends RecipeAttribute {
  Step({required int id, required int recipeId, String? value})
      : super(id: id, recipeId: recipeId, value: value);
}
