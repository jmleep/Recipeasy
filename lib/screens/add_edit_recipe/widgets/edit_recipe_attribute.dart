import 'package:flutter/cupertino.dart';

import '../../../data/model/recipe_attribute.dart';
import 'input_new_recipe_attribute.dart';
import 'list_view_edit_recipe_attributes.dart';

class EditRecipeAttribute extends StatelessWidget {
  final String title;
  final List<RecipeAttribute> items;
  final List<TextEditingController> controllers;
  final Function(String, int) updateItem;
  final Function(int) removeItem;
  final Function(String) addItem;
  final String inputHint;
  final bool isNumbered;

  const EditRecipeAttribute(
      {Key? key,
      required this.title,
      required this.items,
      required this.controllers,
      required this.updateItem,
      required this.removeItem,
      required this.addItem,
      required this.inputHint,
      this.isNumbered = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(fontSize: 30),
          ),
        ),
        EditRecipeAttributesListView(
          key: UniqueKey(),
          recipeItems: items,
          controllers: controllers,
          isNumbered: isNumbered,
          removeItem: (int i) => removeItem(i),
          updateItem: (String text, int i) => updateItem(text, i),
        ),
        NewRecipeAttributeInput(
          inputHint: inputHint,
          isNumbered: isNumbered,
          activeIndex: items.length,
          addAttribute: (String i) => addItem(i),
          key: UniqueKey(),
        ),
      ],
    );
  }
}
