import 'package:flutter/material.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/util/utils.dart';
import 'package:sqflite/sqflite.dart';

import 'recipe_database.dart';

class RecipeDatabaseManager {
  static Future<int> upsertRecipe(Recipe recipe) async {
    final Database db = await RecipeDatabase.instance.database;

    int recipeId = await db.insert(RecipeDatabase.recipeTable, recipe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    var upsertFutures = <Future>[];

    if (recipe.ingredients != null && recipe.ingredients.length > 0) {
      recipe.ingredients.forEach((element) {
        upsertFutures.add(db.insert(
            RecipeDatabase.ingredientsTable, element.toMap(recipeId)));
      });
    }

    if (recipe.steps != null && recipe.steps.length > 0) {
      recipe.steps.forEach((element) {
        upsertFutures
            .add(db.insert(RecipeDatabase.stepsTable, element.toMap(recipeId)));
      });
    }

    Future.wait(upsertFutures);

    return recipeId;
  }

  static Future<void> deleteRecipe(Recipe recipe) async {
    final Database db = await RecipeDatabase.instance.database;

    await db.delete(RecipeDatabase.ingredientsTable,
        where: "recipe_id = ?", whereArgs: [recipe.id]);
    await db.delete(RecipeDatabase.stepsTable,
        where: "recipe_id = ?", whereArgs: [recipe.id]);

    return db.delete(RecipeDatabase.recipeTable,
        where: "id = ?", whereArgs: [recipe.id]);
  }

  static Future<List<Recipe>> allRecipes() async {
    final Database db = await RecipeDatabase.instance.database;

    final List<Map<String, dynamic>> maps =
        await db.query(RecipeDatabase.recipeTable);

    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i]['id'],
        name: maps[i]['name'],
        meatContent:
            Utils.cast<String>(maps[i]['meat_content']).toMeatContent(),
        imagePath: maps[i]['imagePath'],
        color: new Color(maps[i]['color'])
      );
    });
  }
}
