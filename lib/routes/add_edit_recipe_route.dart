import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/util/widget_styles.dart';
import 'package:my_recipes/widgets/recipe_app_bar.dart';

class AddEditRecipe extends StatefulWidget {
  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();
}

class _AddEditRecipeState extends State<AddEditRecipe> {
  final ingredients = List<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: RecipeAppBar(
        title: "Add Recipe",
        isPrimary: false,
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
            FractionallySizedBox(
              widthFactor: 0.5,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Add Ingredient',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (ingredients.length > 0 && ingredients[ingredients.length - 1].isNotEmpty) {
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
            ),
          ],
        ),
      )),
    );
  }
}
