import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:my_recipes/widgets/expansion_panels/expansion_panel_section_view.dart';

import '../../../data/model/recipe_attribute.dart';
import 'list_item_recipe_attribute_view.dart';

class RecipeAttributeExpansionTile extends StatelessWidget {
  final String title;
  final String noItemsText;
  final List<RecipeAttribute> items;
  final bool? isNumbered;

  const RecipeAttributeExpansionTile(
      {Key? key,
      required this.items,
      required this.title,
      required this.noItemsText,
      this.isNumbered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewExpansionPanel(
        title: title,
        isInitiallyExpanded: items.length != 0,
        items: items,
        noItemsText: noItemsText,
        itemBuilder: (context, index) {
          return ViewRecipeAttributeListItem(
              key: UniqueKey(),
              item: items[index],
              index: index,
              isNumbered: isNumbered != null ? isNumbered! : false,
              showDivider: index != items.length - 1);
        });
  }
}
