import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/screens/add_edit_recipe/view_model/view_model_add_edit_recipe.dart';
import 'package:my_recipes/screens/add_edit_recipe/widgets/list_item_edit_ingredient.dart';
import 'package:provider/provider.dart';

import '../../../data/model/recipe_ingredient.dart';

class EditIngredientsListView extends StatelessWidget {
  final List<RecipeIngredient> ingredients;
  final List<TextEditingController> controllers;
  final Function(int) removeIngredient;
  final Function(String, RecipeIngredient) updateIngredient;

  const EditIngredientsListView(
      {required Key key,
      required this.ingredients,
      required this.controllers,
      required this.removeIngredient,
      required this.updateIngredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        context
            .read<AddEditRecipeViewModel>()
            .swapIngredients(oldIndex, newIndex);
      },
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
          child: Row(
            children: [
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: EditIngredientListItem(
                  item: ingredients[index],
                  index: index,
                  updateIngredient: updateIngredient,
                  controller: controllers[index],
                  showTopDivider: index == 0,
                  key: UniqueKey(),
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 30, top: 10),
                child: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle, size: 30),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
