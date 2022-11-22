import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientListItem extends StatelessWidget {
  final String item;
  final bool showDivider;

  const IngredientListItem(
      {Key key, @required this.item, @required this.showDivider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 30, bottom: 5, top: 5),
            child: Text(item)),
        if (showDivider) ...[Divider()]
      ],
    );
  }
}
