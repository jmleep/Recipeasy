import 'package:my_recipes/model/recipe_attribute.dart';

class RecipePhoto extends RecipeAttribute {
  bool isPrimary;

  RecipePhoto({int id, int recipeId, String value, this.isPrimary = false})
      : super(id: id, recipeId: recipeId, value: value);

  @override
  Map<String, dynamic> toMap(int recipeId) {
    Map<String, dynamic> values = super.toMap(recipeId);

    values.addAll({'is_primary': isPrimary ? 1 : 0});

    return values;
  }
}
