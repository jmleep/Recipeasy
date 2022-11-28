import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/repository/recipe_repository.dart';
import 'package:my_recipes/data/repository/recipe_photo_repository.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:my_recipes/data/model/recipe_photo.dart';
import 'package:my_recipes/widgets/buttons/button_recipeasy.dart';

class DeleteRecipeConfirmationDialog extends StatelessWidget {
  final Recipe recipe;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function getRecipes;

  DeleteRecipeConfirmationDialog(
      {required this.recipe,
      required this.scaffoldKey,
      required this.getRecipes});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${recipe.name}"),
      content: Text("Are you sure you want to delete this recipe?"),
      actions: [
        RoundedButton(
          buttonText: 'Cancel',
          textColor: Colors.grey[900],
          borderColor: Colors.grey[900]!,
          fillColor: Colors.grey[300],
          onPressed: () => Navigator.of(context).pop(false),
        ),
        RoundedButton(
          buttonText: 'Delete',
          textColor: Colors.white,
          borderColor: Colors.red[700]!,
          fillColor: Colors.red[700],
          onPressed: () async {
            List<RecipePhoto> photosRefInCaseOfUndo =
                await RecipePhotoDatabaseManager.getImages(recipe.id!);

            await RecipeDatabaseManager.deleteRecipe(recipe);

            getRecipes();

            Navigator.of(context).pop(true);

            final snackBar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              content: Text("${recipe.name} deleted"),
              duration: Duration(seconds: 10),
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'UNDO',
                onPressed: () async {
                  recipe.photos = photosRefInCaseOfUndo;

                  RecipeDatabaseManager.upsertRecipe(recipe)
                      .then((value) => getRecipes());
                },
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ],
    );
  }
}
