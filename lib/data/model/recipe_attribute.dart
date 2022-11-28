class RecipeAttribute {
  final int? id;
  final int? recipeId;
  String? value;

  RecipeAttribute({this.id, this.recipeId, this.value});

  Map<String, dynamic> toMap(int recipeId) {
    Map<String, dynamic> values = new Map();
    values.addAll({'value': value, 'recipe_id': recipeId});

    if (id != null) {
      values['id'] = id;
    }

    return values;
  }
}
