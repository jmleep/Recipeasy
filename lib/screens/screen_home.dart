import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/data/repository/recipe_repository.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:my_recipes/screens/screen_settings.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/button_add_recipe_floating_action.dart';
import 'package:my_recipes/widgets/dialogs/dialog_delete_recipe_confirmation.dart';

import 'add_edit_recipe/screen_add_edit_recipe.dart';
import 'view_recipe_details/screen_view_recipe_details.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  getRecipes() async {
    setState(() => _isLoading = true);
    List<Recipe> recipes = await RecipeDatabaseManager.getHomeGridRecipes();

    setState(() {
      _recipes = recipes;
      _isLoading = false;
    });
  }

  void navigateTo(Recipe? recipe) async {
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

  navigateToSettings() async {
    // Navigator.pushNamed(context, '/profile');

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  List<Widget> buildRecipeGrid() {
    if (_recipes.length > 0) {
      return _recipes
          .map((recipe) => GestureDetector(
                onTap: () async {
                  navigateTo(recipe);
                },
                onLongPress: () async {
                  HapticFeedback.mediumImpact();

                  await showDialog(
                      context: context,
                      builder: (builderContext) =>
                          DeleteRecipeConfirmationDialog(
                            scaffoldKey: _scaffoldKey,
                            recipe: recipe,
                            getRecipes: getRecipes,
                          ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FittedBox(
                                child: recipe.primaryImage != null
                                    ? Image.memory(recipe.primaryImage!)
                                    : Icon(Icons.photo),
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      Container(
                          color: recipe.color != null
                              ? recipe.color
                              : Colors.black,
                          child: Text(
                            recipe.name,
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ))
          .toList();
    }
    return [SizedBox.shrink()];
  }

  @override
  void initState() {
    super.initState();

    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<Widget> grid = buildRecipeGrid();
    Widget body;

    if (grid == null) {
      body = Center(
          child: Text(
        'Click "New Recipe" to add your first recipe!',
        style: TextStyle(fontSize: 16),
      ));
    } else {
      body = GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        children: <Widget>[...grid],
      );
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: RecipeAppBar(
          title: 'Recipeasy', //'My Recipes 🥘',
          allowBack: false,
          actions: [
            AppBarAction(
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                navigateToSettings)
          ],
        ),
        body: body,
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: AddRecipeFloatingActionButton(
          key: UniqueKey(),
          onPressAddRecipeFAB: this.navigateTo,
        ));
  }
}
