import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/ingredient.dart';

class IngredientListItem extends StatelessWidget {
  final Ingredient item;
  final bool showDivider;

  const IngredientListItem(
      {required Key key, required this.item, required this.showDivider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 30, bottom: 5, top: 5),
            child: Text(item.value ?? '')),
        if (showDivider) ...[Divider()]
      ],
    );
  }
}
