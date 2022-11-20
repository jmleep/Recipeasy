import 'dart:typed_data';
import 'dart:ui';

import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/model/recipe_photo.dart';

import 'step.dart';

class Recipe {
  final int id;
  String name;
  List<Ingredient> ingredients;
  List<Step> steps;
  List<RecipePhoto> photos;
  String notes;
  MeatContent meatContent;
  Color color;
  Uint8List primaryImage;

  Recipe(
      {this.id,
      this.name,
      this.ingredients,
      this.steps,
      this.photos,
      this.notes,
      this.meatContent,
      this.color,
      this.primaryImage,});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> values = new Map();
    values.addAll({
      'name': name,
      'notes': notes,
      'meat_content': meatContent.toString(),
      'color': color != null ? color.value : 0,
    });

    if (id != null) {
      values['id'] = id;
    }

    return values;
  }
}

enum MeatContent { meat, vegetarian, vegan }

extension EnumParser on String {
  MeatContent toMeatContent() {
    return MeatContent.values
        .firstWhere((e) => e.toString() == this, orElse: () => null);
  }
}
