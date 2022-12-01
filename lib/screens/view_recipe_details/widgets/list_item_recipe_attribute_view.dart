import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/recipe_attribute.dart';

class ViewRecipeAttributeListItem extends StatelessWidget {
  final RecipeAttribute item;
  final int index;
  final bool showDivider;
  final bool isNumbered;

  const ViewRecipeAttributeListItem(
      {required Key key,
      required this.item,
      required this.showDivider,
      required this.isNumbered,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(color: Theme.of(context).colorScheme.onPrimary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 30, bottom: 5, top: 5, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNumbered)
                  Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        '${index + 1}.',
                        style: style,
                      )),
                Flexible(
                    child: Text(
                  item.value ?? '',
                  softWrap: true,
                  style: style,
                )),
              ],
            )),
        if (showDivider) ...[
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        ]
      ],
    );
  }
}
