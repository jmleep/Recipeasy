import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/buttons/rounded_button.dart';

class DeleteRecipeConfirmationDialog extends StatelessWidget {
  final Recipe recipe;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function getRecipes;

  DeleteRecipeConfirmationDialog({this.recipe, this.scaffoldKey,
      this.getRecipes});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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

            Navigator.of(context).pop(true);

            final snackBar = SnackBar(
              backgroundColor: Theme.of(context).accentColor,
              content: Text("${recipe.name} deleted"),
              duration: Duration(seconds: 10),
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'UNDO',
                onPressed: () async {
                  recipe.photos = photosRefInCaseOfUndo;

                  RecipeDatabaseManager.upsertRecipe(
                      recipe)
                      .then((value) => getRecipes());
                },
              ),
            );

            scaffoldKey.currentState
                .showSnackBar(snackBar);
          },
        ),
      ],
    );
  }
}
