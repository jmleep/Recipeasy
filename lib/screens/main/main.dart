import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/screens/main/recipe_list_item.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_recipes/widgets/dismissible_background.dart';
import '../../model/recipe.dart';
import '../add_edit_recipe/add_edit_recipe.dart';

void main() {
  runApp(MyRecipeApp());
}

class MyRecipeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Recipes',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.white,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.black54,
        brightness: Brightness.dark,
      ),
      home: Main(title: 'My Recipes 🥘'),
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Future<List<Recipe>> recipes;

  @override
  void initState() {
    super.initState();
    recipes = RecipeDatabaseManager.allRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: recipes,
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        Widget child;
        if (snapshot.hasData && snapshot.data.length > 0) {
          child = ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                var recipeName = snapshot.data[index].name;
                var recipeColor = snapshot.data[index].color;
                var recipeImagePath = snapshot.data[index].imagePath;

                return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: UniqueKey(),
                    background: DismissibleBackground(),
                    onDismissed: (direction) async {
                      HapticFeedback.mediumImpact();

                      await RecipeDatabaseManager.deleteRecipe(
                          snapshot.data[index]);
                      var deletedRecipe = snapshot.data[index].name;
                      snapshot.data.removeAt(index);
                      setState(() {
                        recipes = RecipeDatabaseManager.allRecipes();
                      });

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("$deletedRecipe deleted")));
                    },
                    child: RecipeListItem(
                      key: UniqueKey(),
                      recipeName: recipeName,
                      recipeImagePath: recipeImagePath,
                      recipeColor: recipeColor,
                    ));
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 10,
                  ),
              itemCount: snapshot.data.length);
        } else {
          child = Text(
            'Add a recipe!',
          );
        }

        return Scaffold(
          appBar: RecipeAppBar(
            title: widget.title,
            allowBack: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: child),
          ),
          backgroundColor: Theme.of(context).accentColor,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              HapticFeedback.mediumImpact();

              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditRecipe()),
              );

              setState(() {
                recipes = RecipeDatabaseManager.allRecipes();
              });
            },
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.note_add,
              color: Colors.white,
            ),
            label: Text(
              'New Recipe',
              style: GoogleFonts.pacifico(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
