import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/ingredient.dart';

class IngredientListItem extends StatelessWidget {
  final Ingredient item;
  final bool showTopDivider;

  const IngredientListItem({
    Key key,
    this.item,
    this.showTopDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopDivider) ...[
          Divider(
            color: Theme.of(context).colorScheme.secondary,
          )
        ],
        Container(
            padding: EdgeInsets.only(left: 15, bottom: 5, top: 5),
            child: Text(item.value)),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
        )
      ],
    );
  }
}
