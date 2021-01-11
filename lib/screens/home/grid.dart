import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/screens/recipe/add_edit_recipe/add_edit_recipe.dart';
import 'package:my_recipes/screens/recipe/view_recipe/view_recipe.dart';
import 'package:my_recipes/util/utils.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/add_recipe_floating_action_button.dart';
import 'package:my_recipes/widgets/buttons/rounded_button.dart';

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  List<Recipe> _recipes = new List<Recipe>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  getRecipes() async {
    List<Recipe> recipes = await RecipeDatabaseManager.getAllRecipes();

    setState(() {
      _recipes = recipes;
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
                      builder: (builderContext) => new AlertDialog(
                            title: Text("Delete ${recipe.name}"),
                            content: Text(
                                "Are you sure you want to delete this recipe?"),
                            actions: [
                              RoundedButton(
                                buttonText: 'Cancel',
                                textColor: Colors.grey[900],
                                borderColor: Colors.grey[900],
                                fillColor: Colors.grey[300],
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              RoundedButton(
                                buttonText: 'Delete',
                                borderColor: Colors.red[700],
                                fillColor: Colors.red[700],
                                onPressed: () async {
                                  List<RecipePhoto> photosRefInCaseOfUndo =
                                      await RecipePhotoDatabaseManager
                                          .getImages(recipe.id);

                                  await RecipeDatabaseManager.deleteRecipe(
                                      recipe);

                                  getRecipes();

                                  Navigator.of(builderContext).pop(true);

                                  final snackBar = SnackBar(
                                    content: Text("${recipe.name} deleted"),
                                    duration: Duration(seconds: 10),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () async {
                                        recipe.photos = photosRefInCaseOfUndo;

                                        RecipeDatabaseManager.upsertRecipe(
                                                recipe)
                                            .then((value) => getRecipes());
                                      },
                                    ),
                                  );

                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                },
                              ),
                            ],
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
                          child: FutureBuilder(
                              future: Utils.loadFileFromPath(
                                  recipe.primaryPhotoPath),
                              builder: (BuildContext context,
                                  AsyncSnapshot<File> imageFile) {
                                Widget response;

                                if (imageFile.data != null) {
                                  response = Image(
                                    image: FileImage(imageFile.data),
                                  );
                                } else {
                                  response = Icon(Icons.photo);
                                }

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FittedBox(
                                    child: response,
                                    fit: BoxFit.fitWidth,
                                  ),
                                );
                              }),
                        ),
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
          title: 'My Recipes', //'My Recipes 🥘',
          allowBack: false,
        ),
        body: body,
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: AddRecipeFloatingActionButton(
          onPressAddRecipeFAB: this.navigateTo,
        ));
  }
}
