import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/theme/widget_styles.dart';

import '../../../data/model/recipe_ingredient.dart';

class EditIngredientListItem extends StatelessWidget {
  final RecipeIngredient item;
  final bool showTopDivider;
  final TextEditingController controller;
  final Function(String, RecipeIngredient) updateIngredient;
  final int index;

  const EditIngredientListItem(
      {required Key key,
      required this.item,
      this.showTopDivider = false,
      required this.controller,
      required this.updateIngredient,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          textInputAction: TextInputAction.done,
          controller: controller,
          onSubmitted: (value) {
            updateIngredient(controller.value.text, item);
          },
          decoration:
              ReusableStyleWidget.inputThemeUnderlineBorder(context, null, ''),
        ),
      ],
    );
  }
}
