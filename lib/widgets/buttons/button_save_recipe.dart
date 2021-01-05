import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/widgets/buttons/button_primary.dart';

class SaveRecipeButton extends StatelessWidget {
  const SaveRecipeButton({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required List<Ingredient> ingredients,
    @required TextEditingController nameController,
    @required imagePath,
    @required MaterialColor recipeColor,
  })  : _formKey = formKey,
        _ingredients = ingredients,
        _nameController = nameController,
        _imagePath = imagePath,
        _recipeColor = recipeColor,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final List<Ingredient> _ingredients;
  final TextEditingController _nameController;
  final _imagePath;
  final MaterialColor _recipeColor;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
        icon: Icons.save,
        text: 'Save',
        onButtonPress: () {
          HapticFeedback.mediumImpact();

          if (_formKey.currentState.validate()) {

            Recipe r = new Recipe(
                name: _nameController.text,
                notes: 'yum!',
                meatContent: MeatContent.meat,
                ingredients: _ingredients,
                primaryImagePath: _imagePath,
                color: _recipeColor);

            RecipeDatabaseManager.upsertRecipe(r);

            Navigator.pop(context);
          }
        });
  }
}
