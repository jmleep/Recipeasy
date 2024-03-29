import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RecipeDatabase {
  static const databaseName = "recipe.db";

  static const recipeTable = 'recipes';
  static const ingredientsTable = 'ingredients';
  static const stepsTable = 'steps';
  static const photosTable = 'photos';
  static const tagsTable = 'tags';

  // Private constructor to enforce singleton
  RecipeDatabase._();

  static final RecipeDatabase instance = RecipeDatabase._();

  static Database? _database;

  // Create getter
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    return await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), databaseName),

      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          '''CREATE TABLE $recipeTable(id INTEGER PRIMARY KEY, name TEXT, notes TEXT, meat_content TEXT, color INTEGER, list_order INTEGER)''',
        );
        db.execute(
          '''CREATE TABLE $ingredientsTable(id INTEGER PRIMARY KEY, recipe_id INTEGER, value TEXT, list_order INTEGER)''',
        );
        db.execute(
          '''CREATE TABLE $stepsTable(id INTEGER PRIMARY KEY, recipe_id INTEGER, value TEXT, list_order INTEGER)''',
        );
        db.execute(
          '''CREATE TABLE $photosTable(id INTEGER PRIMARY KEY, recipe_id INTEGER, is_primary INTEGER, image TEXT)''',
        );
        db.execute(
          '''CREATE TABLE $tagsTable(id INTEGER PRIMARY KEY, recipe_id INTEGER, value TEXT, list_order INTEGER)''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}
