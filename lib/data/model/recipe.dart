import 'dart:typed_data';
import 'dart:ui';

import 'package:my_recipes/data/model/recipe_photo.dart';

import 'recipe_ingredient.dart';

import 'recipe_step.dart';

class Recipe {
  final int? id;
  String name;
  int? order;
  List<RecipeIngredient>? ingredients;
  List<RecipeStep>? steps;
  List<RecipePhoto>? photos;
  String? notes;
  MeatContent? meatContent;
  Color? color;
  Uint8List? primaryImage;

  Recipe({
    this.id,
    required this.name,
    this.order,
    this.ingredients,
    this.steps,
    this.photos,
    this.notes,
    this.meatContent,
    this.color,
    this.primaryImage,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> values = new Map();
    values.addAll({
      'name': name,
      'notes': notes,
      'meat_content': meatContent.toString(),
      'color': color != null ? color?.value : 0,
    });

    if (id != null) {
      values['id'] = id;
    }

    if (order != null) {
      values['list_order'] = order;
    }

    return values;
  }
}

enum MeatContent { meat, vegetarian, vegan }

extension EnumParser on String {
  MeatContent toMeatContent() {
    return MeatContent.values.firstWhere((e) => e.toString() == this,
        orElse: () => MeatContent.meat);
  }
}
