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
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            child: Text(item.value)),
        Divider(
          height: 1,
          color: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }
}
