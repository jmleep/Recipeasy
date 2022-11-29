import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/model/recipe.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../add_edit_recipe/screen_add_edit_recipe.dart';
import '../../settings/screen_settings.dart';
import '../../view_recipe_details/screen_view_recipe_details.dart';

class HomeViewModel extends ChangeNotifier {
  late List<Recipe> recipes;
  bool isLoading = true;

  init() {
    recipes = [];
    getRecipes();
  }

  getRecipes() async {
    List<Recipe> retrievedRecipes = await RecipeDatabaseManager.getAllRecipes();

    recipes = retrievedRecipes;
    isLoading = false;
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
}
