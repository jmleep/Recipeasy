import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:my_recipes/screens/view_recipe_details/view_model/view_model_view_recipe_details.dart';
import 'package:my_recipes/screens/view_recipe_details/widgets/list_item_ingredient_view.dart';
import 'package:provider/provider.dart';

class IngredientsExpansionTile extends StatelessWidget {
  const IngredientsExpansionTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Ingredients', style: TextStyle(fontSize: 25)),
      initiallyExpanded:
          context.watch<ViewRecipeViewModel>().recipeIngredients.length != 0,
      children: [
        context.watch<ViewRecipeViewModel>().recipeIngredients.length == 0
            ? Container(
                padding: EdgeInsets.all(10),
                child: Text("No ingredients added"))
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: context
                    .watch<ViewRecipeViewModel>()
                    .recipeIngredients
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  return ViewIngredientListItem(
                      key: UniqueKey(),
                      item: context
                          .watch<ViewRecipeViewModel>()
                          .recipeIngredients[index],
                      showDivider: index !=
                          context
                                  .watch<ViewRecipeViewModel>()
                                  .recipeIngredients
                                  .length -
                              1);
                })
      ],
    );
  }
}
