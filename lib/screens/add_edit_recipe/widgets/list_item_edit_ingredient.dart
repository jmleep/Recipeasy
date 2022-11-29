import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/theme/widget_styles.dart';

import '../../../data/model/ingredient.dart';

class EditIngredientListItem extends StatelessWidget {
  final Ingredient item;
  final bool showTopDivider;
  final TextEditingController controller;
  final Function(String, Ingredient) updateIngredient;

  const EditIngredientListItem(
      {required Key key,
      required this.item,
      this.showTopDivider = false,
      required this.controller,
      required this.updateIngredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: controller,
              onSubmitted: (value) {
                updateIngredient(controller.value.text, item);
              },
              decoration: ReusableStyleWidget.inputThemeUnderlineBorder(
                  context, null, ''),
            )),
      ],
    );
  }
}
