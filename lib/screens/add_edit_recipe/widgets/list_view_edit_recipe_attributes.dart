import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_attribute.dart';
import 'package:my_recipes/screens/add_edit_recipe/view_model/view_model_add_edit_recipe.dart';
import 'package:my_recipes/screens/add_edit_recipe/widgets/list_item_edit_recipe_attribute.dart';
import 'package:provider/provider.dart';

class EditRecipeAttributesListView extends StatelessWidget {
  final List<RecipeAttribute> recipeItems;
  final List<TextEditingController> controllers;
  final Function(int) removeItem;
  final Function(String, int) updateItem;
  final bool isNumbered;

  const EditRecipeAttributesListView(
      {required Key key,
      required this.recipeItems,
      required this.controllers,
      required this.removeItem,
      required this.updateItem,
      required this.isNumbered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[500]?.withOpacity(0.5),
          shadowColor: Colors.grey[500]),
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          context
              .read<AddEditRecipeViewModel>()
              .reorderItems(recipeItems, oldIndex, newIndex);
        },
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 5),
        physics: NeverScrollableScrollPhysics(),
        itemCount: recipeItems.length,
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
              removeItem(index);
            },
            key: UniqueKey(),
            child: Row(
              children: [
                if (isNumbered)
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 5, top: 10),
                    child: Text('${index + 1}'),
                  ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: EditRecipeAttributeListItem(
                    item: recipeItems[index],
                    index: index,
                    updateItem: (newValue) => updateItem(newValue, index),
                    controller: controllers[index],
                    showTopDivider: index == 0,
                    key: UniqueKey(),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 30, top: 10),
                  child: ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle,
                        size: 30,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
