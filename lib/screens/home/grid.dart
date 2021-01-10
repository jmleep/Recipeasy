import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/screens/add_edit_recipe/add_edit_recipe.dart';
import 'package:my_recipes/screens/view_recipe/view_recipe.dart';
import 'package:my_recipes/util/utils.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/add_recipe_floating_action_button.dart';

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  Future<List<Recipe>> recipes;

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

    setState(() {
      recipes = RecipeDatabaseManager.getAllRecipes();
    });
  }

  List<Widget> buildRecipeGrid(AsyncSnapshot<List<Recipe>> snapshot) {
    if (snapshot.hasData && snapshot.data.length > 0) {
      return snapshot.data
          .map((recipe) => GestureDetector(
                onTap: () async {
                  navigateTo(recipe);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: Colors.grey,
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
                                  borderRadius: BorderRadius.circular(4.0),
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
    recipes = RecipeDatabaseManager.getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: recipes,
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        List<Widget> grid = buildRecipeGrid(snapshot);
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
            appBar: RecipeAppBar(
              title: 'My Recipes 🥘',
              allowBack: false,
            ),
            body: body,
            backgroundColor: Theme.of(context).accentColor,
            floatingActionButton: AddRecipeFloatingActionButton(
              onPressAddRecipeFAB: this.navigateTo,
            ));
      },
    );
  }
}
