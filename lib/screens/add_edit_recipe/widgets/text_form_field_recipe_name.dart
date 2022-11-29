import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/theme/widget_styles.dart';

class RecipeNameTextFormField extends StatelessWidget {
  final GlobalKey formKey;
  final TextEditingController recipeNameController;

  RecipeNameTextFormField(
      {required this.formKey, required this.recipeNameController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: TextFormField(
          controller: recipeNameController,
          decoration:
              ReusableStyleWidget.inputDecoration(context, 'Recipe Name'),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter a recipe name!';
            }
            return null;
          },
        ),
      ),
    );
  }
}
