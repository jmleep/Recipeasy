import 'dart:ui';

import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/model/recipe_photo.dart';

import 'ingredient.dart';
import 'step.dart';

class Recipe {
  final int id;
  String name;
  List<Ingredient> ingredients;
  List<Step> steps;
  List<RecipePhoto> photos;
  String notes;
  MeatContent meatContent;
  String primaryImagePath;
  Color color;

  Recipe(
      {this.id,
      this.name,
      this.ingredients,
      this.steps,
      this.photos,
      this.notes,
      this.meatContent,
      this.primaryImagePath,
      this.color});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> values = new Map();
    values.addAll({
      'name': name,
      'notes': notes,
      'meat_content': meatContent.toString(),
      'primaryImagePath': primaryImagePath,
      'color': color != null ? color.value : 0
    });

    if (id != null) {
      values['id'] = id;
    }

    return values;
  }
}

enum MeatContent {
  meat,
  vegetarian,
  vegan
}

extension EnumParser on String {
  MeatContent toMeatContent() {
    return MeatContent.values.firstWhere((e) => e.toString() == this, orElse: () => null);
  }
}
