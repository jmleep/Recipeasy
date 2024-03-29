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
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: Form(
        key: formKey,
        child: TextFormField(
          buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) =>
              Container(
            alignment: Alignment.centerRight,
            child: Text(currentLength.toString() + "/" + maxLength.toString()),
          ),
          autofocus: false,
          textInputAction: TextInputAction.next,
          maxLength: 40,
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
