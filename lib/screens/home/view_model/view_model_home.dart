import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/recipe.dart';
import '../../../data/model/recipe_tag.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../add_edit_recipe/screen_add_edit_recipe.dart';
import '../../settings/screen_settings.dart';
import '../../view_recipe_details/screen_view_recipe_details.dart';

class HomeViewModel extends ChangeNotifier {
  static const preferences_grid_column_count = 'preferences_grid_column_count';
  static const preferences_is_grid = 'preferences_is_grid';

  late List<Recipe> recipes;
  List<Recipe> filteredRecipes = [];
  List<RecipeTag> allRecipeTags = [];
  List<RecipeTag> activeFilteredTags = [];
  List<RecipeTag> tempFilteredTags = [];
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
    filteredRecipes = [];
    final prefs = await SharedPreferences.getInstance();
    var prefsIsGrid = prefs.getBool(preferences_is_grid);
    var prefsGridColumnCount = prefs.getInt(preferences_grid_column_count);

    if (prefsIsGrid == null) {
      prefs.setBool(preferences_is_grid, true);
      isGrid = true;
    } else {
      isGrid = prefsIsGrid;
    }

    if (prefsGridColumnCount == null) {
      prefs.setInt(preferences_grid_column_count, 2);
      gridColumnCount = 2;
    } else {
      gridColumnCount = prefsGridColumnCount;
    }

    getRecipes();
  }

  setGridColumnCount(int columnCount) async {
    isGrid = true;
    gridColumnCount = columnCount;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(preferences_grid_column_count, columnCount);
    prefs.setBool(preferences_is_grid, true);

    notifyListeners();
  }

  getRecipeTags() async {
    allRecipeTags = await RecipeDatabaseManager.getAllTags();
    notifyListeners();
  }

  getRecipes() async {
    List<Recipe> retrievedRecipes = await RecipeDatabaseManager.getAllRecipes();

    recipes = retrievedRecipes;
    filteredRecipes = [...recipes];
    isLoading = false;
    if (retrievedRecipes.length > 0) {
      isAnyRecipePresent = true;
    }
    filterRecipesByTag();
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

  toggleTagFilter(RecipeTag tag) {
    if (tempFilteredTags.any(
      (element) => element.value == tag.value,
    )) {
      tempFilteredTags.removeWhere((element) => element.value == tag.value);
    } else {
      tempFilteredTags.add(tag);
    }

    notifyListeners();
  }

  filterRecipesByTag() {
    activeFilteredTags = [...tempFilteredTags];

    if (activeFilteredTags.isEmpty) {
      filteredRecipes = [...recipes];
    } else {
      filteredRecipes = [];
    }

    for (var i = 0; i < recipes.length; i++) {
      var tagLength = recipes[i].tags?.length ?? 0;
      for (var j = 0; j < tagLength; j++) {
        if (activeFilteredTags
            .any((activeTag) => activeTag.value == recipes[i].tags?[j].value)) {
          filteredRecipes.add(recipes[i]);
          break;
        }
      }
    }

    notifyListeners();
  }

  removeActiveTag(RecipeTag tag) {
    activeFilteredTags.removeWhere((element) => element.value == tag.value);
    tempFilteredTags.removeWhere((element) => element.value == tag.value);

    filterRecipesByTag();
    notifyListeners();
  }
}
