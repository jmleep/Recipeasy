import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_step.dart';
import 'package:my_recipes/data/repository/recipe_photo_repository.dart';
import 'package:my_recipes/data/model/recipe_ingredient.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:sqflite/sqflite.dart';

import '../recipe_database.dart';

class RecipeDatabaseManager {
  static Future<int> upsertRecipe(Recipe recipe) async {
    final Database? db = await RecipeDatabase.instance.database;

    int recipeId = await db!.insert(RecipeDatabase.recipeTable, recipe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    Batch ingredientsBatch = db.batch();
    if (recipe.ingredients != null && recipe.ingredients!.length > 0) {
      recipe.ingredients?.asMap().forEach((index, value) {
        ingredientsBatch.insert(
            RecipeDatabase.ingredientsTable, value.toMap(recipeId, index),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    }

    Batch stepsBatch = db.batch();
    if (recipe.steps != null && recipe.steps!.length > 0) {
      recipe.steps?.asMap().forEach((index, element) {
        stepsBatch.insert(
            RecipeDatabase.stepsTable, element.toMap(recipeId, index),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    }

    await ingredientsBatch.commit(noResult: true);
    await stepsBatch.commit(noResult: true);

    return recipeId;
  }

  static Future<int> deleteRecipe(Recipe recipe) async {
    final Database? db = await RecipeDatabase.instance.database;

    await db!.delete(RecipeDatabase.ingredientsTable,
        where: "recipe_id = ?", whereArgs: [recipe.id]);
    await db.delete(RecipeDatabase.stepsTable,
        where: "recipe_id = ?", whereArgs: [recipe.id]);

    RecipePhotoDatabaseManager.deletePhotosForRecipe(recipe.id);

    return db.delete(RecipeDatabase.recipeTable,
        where: "id = ?", whereArgs: [recipe.id]);
  }

  static Future<List<RecipeIngredient>> getIngredients(int? recipeId) async {
    final Database? db = await RecipeDatabase.instance.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        RecipeDatabase.ingredientsTable,
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
        orderBy: 'list_order');

    return List.generate(maps.length, (i) {
      return RecipeIngredient(
          id: maps[i]['id'], recipeId: recipeId, value: maps[i]['value']);
    });
  }

  static Future<List<Recipe>> getAllRecipes() async {
    final Database? db = await RecipeDatabase.instance.database;

    final String recipeTable = RecipeDatabase.recipeTable;
    final String photosTable = RecipeDatabase.photosTable;

    final List<Map<String, dynamic>> maps = await db!.rawQuery('' +
        'SELECT $recipeTable.id, $recipeTable.name, $recipeTable.list_order, $recipeTable.color, $recipeTable.meat_content, $photosTable.image ' +
        'FROM $recipeTable ' +
        'LEFT JOIN $photosTable ' +
        'ON $photosTable.recipe_id = $recipeTable.id ' +
        'AND $photosTable.is_primary = 1 ' +
        'ORDER BY $recipeTable.list_order DESC');

    return List.generate(maps.length, (i) {
      return Recipe(
          id: maps[i]['id'],
          name: maps[i]['name'],
          order: maps[i]['order'],
          meatContent: cast<String>(maps[i]['meat_content'])?.toMeatContent(),
          color: new Color(maps[i]['color']),
          primaryImage: maps[i]['image'] != null
              ? base64.decode(maps[i]['image'])
              : null);
    });
  }

  static Future<Recipe> getRecipe(int recipeId) async {
    final Database? db = await RecipeDatabase.instance.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        RecipeDatabase.recipeTable,
        where: 'id = ?',
        whereArgs: [recipeId]);

    return Recipe(
      id: maps[0]['id'],
      name: maps[0]['name'],
      meatContent: cast<String>(maps[0]['meat_content'])?.toMeatContent(),
      color: new Color(maps[0]['color']),
    );
  }

  static Future<void> deleteIngredients(
      List<RecipeIngredient> ingredients) async {
    final Database? db = await RecipeDatabase.instance.database;

    Batch batch = db!.batch();

    ingredients.forEach((element) {
      batch.delete(RecipeDatabase.ingredientsTable,
          where: 'id = ?', whereArgs: [element.id]);
    });

    batch.apply();
  }

  static T? cast<T>(x) => x is T ? x : null;

  static Future<List<RecipeStep>> getSteps(int? recipeId) async {
    final Database? db = await RecipeDatabase.instance.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        RecipeDatabase.stepsTable,
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
        orderBy: 'list_order');

    return List.generate(maps.length, (i) {
      return RecipeStep(
          id: maps[i]['id'], recipeId: recipeId, value: maps[i]['value']);
    });
  }

  static Future<void> deleteSteps(List<RecipeStep> steps) async {
    final Database? db = await RecipeDatabase.instance.database;

    Batch batch = db!.batch();

    steps.forEach((element) {
      batch.delete(RecipeDatabase.stepsTable,
          where: 'id = ?', whereArgs: [element.id]);
    });

    batch.apply();
  }
}
