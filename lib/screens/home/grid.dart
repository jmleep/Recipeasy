import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/add_recipe_floating_action_button.dart';
import 'package:my_recipes/widgets/dialogs/dialog_delete_recipe_confirmation.dart';

import '../add_edit_recipe/add_edit_recipe.dart';
import '../view_recipe/view_recipe.dart';

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  getRecipes() async {
    setState(() => _isLoading = true);
    List<Recipe> recipes = await RecipeDatabaseManager.getAllRecipes();

    setState(() {
      _recipes = recipes;
      _isLoading = false;
    });
  }

  void navigateTo(Recipe recipe) async {
    HapticFeedback.mediumImpact();

    if (recipe != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewRecipe(
                  recipe: recipe,
                )),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddEditRecipe()),
      );
    }

    getRecipes();
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
                                color: Theme.of(context).backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FittedBox(
                                child: recipe.primaryImage != null
                                    ? Image.memory(recipe.primaryImage)
                                    : Icon(Icons.photo),
                                fit: BoxFit.fitWidth,
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
    return null;
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
        ),
        body: body,
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: AddRecipeFloatingActionButton(
          onPressAddRecipeFAB: this.navigateTo,
        ));
  }
}
