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
          id: maps[i]['id'], recipeId: recipeId, value: maps[i]['value']);
    });
  }

  static Future<void> deletePhotosForRecipe(int recipeId) async {
    final Database db = await RecipeDatabase.instance.database;

    await db.delete(RecipeDatabase.photosTable, where: "recipe_id = ?", whereArgs: [recipeId]);
  }

  static Future<void> deletePhoto(int id) async {
    final Database db = await RecipeDatabase.instance.database;

    await db.delete(RecipeDatabase.photosTable, where: "id = ?", whereArgs: [id]);
  }
}