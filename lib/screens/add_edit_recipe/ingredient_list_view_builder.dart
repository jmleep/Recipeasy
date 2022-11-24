import 'package:flutter/cupertino.dart';
import 'package:my_recipes/screens/add_edit_recipe/ingredient_list_item.dart';

import '../../model/ingredient.dart';

class IngredientListViewBuilder extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientListViewBuilder({Key key, this.ingredients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 5),
      physics: NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return IngredientListItem(
          item: ingredients[index],
          showTopDivider: index == 0,
        );
      },
    );
  }
}
