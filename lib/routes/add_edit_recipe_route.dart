import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/util/widget_styles.dart';
import 'package:my_recipes/widgets/button_primary.dart';
import 'package:my_recipes/widgets/primary_mini_button.dart';
import 'package:my_recipes/widgets/recipe_app_bar.dart';

class AddEditRecipe extends StatefulWidget {
  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();
}

class _AddEditRecipeState extends State<AddEditRecipe> {
  final ingredients = List<String>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: RecipeAppBar(
        title: "Add Recipe",
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: nameController,
                decoration: ReusableStyleWidget.inputDecoration(
                    context, 'Recipe Name')),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return TextFormField(
                  autofocus: ingredients[index].isEmpty,
                  decoration: InputDecoration(
                      hintText: 'ingredient...', fillColor: Colors.black54),
                  initialValue: ingredients[index],
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            PrimaryMiniButton(
              icon: Icons.add_circle_outline,
              onButtonPress: () {
                HapticFeedback.mediumImpact();
                if (ingredients.length > 0 &&
                    ingredients[ingredients.length - 1].isNotEmpty) {
                  setState(() {
                    ingredients.add('');
                  });
                } else {
                  setState(() {
                    ingredients.add('');
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Spacer(),
            PrimaryButton(
                icon: Icons.save,
                text: 'Save',
                onButtonPress: () {
                  HapticFeedback.mediumImpact();

                  List<Ingredient> userIngredients =
                      ingredients.map((e) => Ingredient(value: e)).toList();

                  Recipe r = new Recipe(
                      name: nameController.text,
                      notes: 'yum!',
                      meatContent: MeatContent.meat,
                      ingredients: userIngredients);

                  RecipeDatabaseManager.upsertRecipe(r);

                  Navigator.pop(context);
                }),
            SizedBox(
              height: 15,
            )
          ],
        ),
      )),
    );
  }
}
