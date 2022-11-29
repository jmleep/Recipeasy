import 'package:my_recipes/data/model/recipe_attribute.dart';

class Ingredient extends RecipeAttribute {
  Ingredient({int? id, int? recipeId, String? value})
      : super(id: id, recipeId: recipeId, value: value);

  Ingredient copyWith(
    int? id,
    int? recipeId,
    String? value,
  ) {
    return Ingredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      value: value ?? this.value,
    );
  }
}
