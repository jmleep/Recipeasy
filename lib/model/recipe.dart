import 'dart:ui';

import 'package:my_recipes/model/ingredient.dart';
import 'package:flutter/foundation.dart';
import 'ingredient.dart';
import 'step.dart';

class Recipe {
  final int id;
  final String name;
  final List<Ingredient> ingredients;
  final List<Step> steps;
  final String notes;
  final MeatContent meatContent;
  final String imagePath;
  final Color color;

  Recipe({this.id, this.name, this.ingredients, this.steps, this.notes,
    this.meatContent, this.imagePath, this.color});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> values = new Map();
    values.addAll({
      'name': name,
      'notes': notes,
      'meat_content': meatContent.toString(),
      'imagePath': imagePath,
      'color': color.value
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
