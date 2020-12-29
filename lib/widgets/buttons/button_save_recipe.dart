import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/widgets/buttons/button_primary.dart';

class SaveRecipeButton extends StatelessWidget {
  const SaveRecipeButton({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required List<String> ingredients,
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
  final List<String> _ingredients;
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
            List<Ingredient> userIngredients =
                _ingredients.map((e) => Ingredient(value: e)).toList();

            Recipe r = new Recipe(
                name: _nameController.text,
                notes: 'yum!',
                meatContent: MeatContent.meat,
                ingredients: userIngredients,
                imagePath: _imagePath,
                color: _recipeColor);

            RecipeDatabaseManager.upsertRecipe(r);

            Navigator.pop(context);
          }
        });
  }
}
