import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_attribute.dart';
import 'package:my_recipes/theme/widget_styles.dart';

class EditRecipeAttributeListItem extends StatelessWidget {
  final RecipeAttribute item;
  final bool showTopDivider;
  final TextEditingController controller;
  final Function(String) updateItem;
  final int index;

  const EditRecipeAttributeListItem(
      {required Key key,
      required this.item,
      this.showTopDivider = false,
      required this.controller,
      required this.updateItem,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          maxLines: null,
          textInputAction: TextInputAction.done,
          controller: controller,
          onSubmitted: (value) {
            updateItem(controller.value.text);
          },
          decoration:
              ReusableStyleWidget.inputThemeUnderlineBorder(context, null, ''),
        ),
      ],
    );
  }
}
