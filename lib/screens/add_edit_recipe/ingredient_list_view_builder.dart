import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/screens/add_edit_recipe/ingredient_list_item.dart';

import '../../model/ingredient.dart';

class IngredientListViewBuilder extends StatelessWidget {
  final List<Ingredient> ingredients;
  final List<TextEditingController> controllers;
  final Function(int) removeIngredient;
  final Function(String, Ingredient) updateIngredient;

  const IngredientListViewBuilder(
      {Key key,
      this.ingredients,
      this.controllers,
      this.removeIngredient,
      this.updateIngredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 5),
      physics: NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Dismissible(
            direction: DismissDirection.endToStart,
            background: Container(
                color: Colors.red,
                //margin: EdgeInsets.only(top: 9, bottom: 9),
                alignment: Alignment.center,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ))),
            onDismissed: (DismissDirection direction) {
              removeIngredient(index);
            },
            key: UniqueKey(),
            child: IngredientListItem(
              item: ingredients[index],
              updateIngredient: updateIngredient,
              controller: controllers[index],
              showTopDivider: index == 0,
            ));
      },
    );
  }
}
