import 'dart:convert';
import 'dart:core';

import 'package:my_recipes/database/recipe_database.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:sqflite/sqflite.dart';

class RecipePhotoDatabaseManager {
  static Future<List<RecipePhoto>> getImages(int recipeId) async {
    final Database db = await RecipeDatabase.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
        RecipeDatabase.photosTable,
        where: 'recipe_id = ?',
        whereArgs: [recipeId]);

    return List.generate(maps.length, (i) {
      return RecipePhoto(
          id: maps[i]['id'],
          recipeId: recipeId,
          image:
              maps[i]['image'] != null ? base64.decode(maps[i]['image']) : null,
          isPrimary: maps[i]['is_primary'] > 0 ? true : false);
    });
  }

  static Future<void> savePhotos(int recipeId, List<RecipePhoto> photos) async {
    final Database db = await RecipeDatabase.instance.database;

    Batch batch = db.batch();

    photos.forEach((element) {
      Map<String, dynamic> elements = element.toMap(recipeId);

      batch.insert(RecipeDatabase.photosTable, elements,
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    await batch.commit(noResult: true);
  }

  // static Future<RecipePhoto> getPrimaryImage(int recipeId) async {
  //   final Database db = await RecipeDatabase.instance.database;
  //
  //   final List<Map<String, dynamic>> maps = await db.query(
  //       RecipeDatabase.photosTable,
  //       where: 'recipe_id = ?',
  //       whereArgs: [recipeId]);
  //
  //   return RecipePhoto(
  //       id: maps[0]['id'],
  //       recipeId: recipeId,
  //       value: maps[0]['value'],
  //       isPrimary: maps[0]['is_primary'] > 0 ? true : false);
  // }

  static Future<void> deletePhotosForRecipe(int recipeId) async {
    final Database db = await RecipeDatabase.instance.database;

    await db.delete(RecipeDatabase.photosTable,
        where: "recipe_id = ?", whereArgs: [recipeId]);
  }

  static Future<void> deletePhotos(List<RecipePhoto> photos) async {
    final Database db = await RecipeDatabase.instance.database;

    List<int> ids = photos.map((e) => e.id).toList();

    if (ids.isNotEmpty) {
      await db.delete(RecipeDatabase.photosTable,
          where: "id IN (${ids.join(', ')})");
    }
  }
}
