import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/util/widget_styles.dart';
import 'package:my_recipes/widgets/recipe_app_bar.dart';

class AddEditRecipe extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RecipeAppBar(
        title: "Add Recipe",
        isPrimary: false,
      ),
      body: Form(
          child: Padding(
            padding: const EdgeInsets.all(10), child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: ReusableStyleWidget.inputDecoration(context, 'Recipe Name')
              )
            ],
          ),)
      ),
    );
  }
}
