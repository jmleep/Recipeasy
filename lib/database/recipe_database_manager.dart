import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/ingredient.dart';
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
            RecipeDatabase.ingredientsTable, element.toMap(recipeId),
            conflictAlgorithm: ConflictAlgorithm.replace));
      });
    }

    if (recipe.steps != null && recipe.steps.length > 0) {
      recipe.steps.forEach((element) {
        upsertFutures.add(db.insert(
            RecipeDatabase.stepsTable, element.toMap(recipeId),
            conflictAlgorithm: ConflictAlgorithm.replace));
      });
    }

    await Future.wait(upsertFutures);

    return recipeId;
  }

  static Future<void> deleteRecipe(Recipe recipe) async {
    final Database db = await RecipeDatabase.instance.database;

    await db.delete(RecipeDatabase.ingredientsTable,
        where: "recipe_id = ?", whereArgs: [recipe.id]);
    await db.delete(RecipeDatabase.stepsTable,
        where: "recipe_id = ?", whereArgs: [recipe.id]);

    RecipePhotoDatabaseManager.deletePhotosForRecipe(recipe.id);

    return db.delete(RecipeDatabase.recipeTable,
        where: "id = ?", whereArgs: [recipe.id]);
  }

  static Future<List<Ingredient>> getIngredients(int recipeId) async {
    final Database db = await RecipeDatabase.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
        RecipeDatabase.ingredientsTable,
        where: 'recipe_id = ?',
        whereArgs: [recipeId]);

    return List.generate(maps.length, (i) {
      return Ingredient(
          id: maps[i]['id'], recipeId: recipeId, value: maps[i]['value']);
    });
  }

  static Future<List<Recipe>> getAllRecipes() async {
    final Database db = await RecipeDatabase.instance.database;

    final String recipeTable = RecipeDatabase.recipeTable;
    final String photosTable = RecipeDatabase.photosTable;

    final List<Map<String, dynamic>> maps = await db.rawQuery('' +
        'SELECT $recipeTable.id, $recipeTable.name, $recipeTable.list_order, $recipeTable.color, $recipeTable.meat_content, $photosTable.image ' +
        'FROM $recipeTable ' +
        'INNER JOIN $photosTable ON $photosTable.recipe_id = $recipeTable.id ' +
        'WHERE $photosTable.is_primary = 1 ' +
        'ORDER BY $recipeTable.list_order DESC');

    return List.generate(maps.length, (i) {
      return Recipe(
          id: maps[i]['id'],
          name: maps[i]['name'],
          order: maps[i]['order'],
          meatContent:
              Utils.cast<String>(maps[i]['meat_content']).toMeatContent(),
          color: new Color(maps[i]['color']),
          primaryImage: maps[i]['image'] != null
              ? base64.decode(maps[i]['image'])
              : null);
    });
  }

  static Future<Recipe> getRecipe(int recipeId) async {
    final Database db = await RecipeDatabase.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
        RecipeDatabase.recipeTable,
        where: 'id = ?',
        whereArgs: [recipeId]);

    return Recipe(
      id: maps[0]['id'],
      name: maps[0]['name'],
      meatContent: Utils.cast<String>(maps[0]['meat_content']).toMeatContent(),
      color: new Color(maps[0]['color']),
    );
  }
}
