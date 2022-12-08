import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/recipe.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../add_edit_recipe/screen_add_edit_recipe.dart';
import '../../settings/screen_settings.dart';
import '../../view_recipe_details/screen_view_recipe_details.dart';

class HomeViewModel extends ChangeNotifier {
  static const preferences_grid_column_count = 'preferences_grid_column_count';
  static const preferences_is_grid = 'preferences_is_grid';

  late List<Recipe> recipes;
  int gridColumnCount = 2;
  bool isLoading = true;
  bool isSearchLoading = false;
  bool isGrid = true;
  Timer? debounce;
  bool isAnyRecipePresent = false;

  @mustCallSuper
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  init() async {
    recipes = [];
    final prefs = await SharedPreferences.getInstance();
    var prefsIsGrid = prefs.getBool(preferences_is_grid);
    var prefsGridColumnCount = prefs.getInt(preferences_grid_column_count);

    if (prefsIsGrid == null || !prefsIsGrid) {
      isGrid = false;
    } else {
      isGrid = true;
    }

    if (prefsGridColumnCount != null) {
      gridColumnCount = prefsGridColumnCount;
    }

    getRecipes();
  }

  setGridColumnCount(int columnCount) async {
    isGrid = true;
    gridColumnCount = columnCount;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(preferences_grid_column_count, columnCount);

    notifyListeners();
  }

  getRecipes() async {
    List<Recipe> retrievedRecipes = await RecipeDatabaseManager.getAllRecipes();

    recipes = retrievedRecipes;
    isLoading = false;
    if (retrievedRecipes.length > 0) {
      isAnyRecipePresent = true;
    }
    notifyListeners();
  }

  void navigateTo(BuildContext context, Recipe? recipe) async {
    HapticFeedback.mediumImpact();

    if (recipe != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewRecipeDetailsScreen(
                  recipe: recipe,
                )),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddEditRecipeScreen()),
      );
    }

    isLoading = true;
    notifyListeners();
    getRecipes();
  }

  navigateToSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  void setIsGrid(bool isGrid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(preferences_is_grid, isGrid);

    this.isGrid = isGrid;
    notifyListeners();
  }

  setIsSearchLoading(bool isLoadingInput) {
    isSearchLoading = isLoadingInput;
    notifyListeners();
  }

  searchRecipes(String text) {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
    debounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        recipes = await RecipeDatabaseManager.searchRecipes(text);
        isSearchLoading = false;
        notifyListeners();
      },
    );
  }
}
