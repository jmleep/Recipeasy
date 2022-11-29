import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/screens/home/view_model/view_model_home.dart';
import 'package:provider/provider.dart';

import '../../../widgets/dialogs/dialog_delete_recipe_confirmation.dart';

class RecipeGrid extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const RecipeGrid({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<RecipeGrid> createState() => _RecipeGridState();
}

class _RecipeGridState extends State<RecipeGrid> {
  @override
  Widget build(BuildContext context) {
    var recipes = context.watch<HomeViewModel>().recipes;

    var gridItems = [];
    if (recipes.length > 0) {
      gridItems = recipes
          .map((recipe) => GestureDetector(
                onTap: () async {
                  context.read<HomeViewModel>().navigateTo(context, recipe);
                },
                onLongPress: () async {
                  HapticFeedback.mediumImpact();

                  await showDialog(
                      context: context,
                      builder: (builderContext) =>
                          DeleteRecipeConfirmationDialog(
                            scaffoldKey: widget.scaffoldKey,
                            recipe: recipe,
                            getRecipes:
                                context.read<HomeViewModel>().getRecipes,
                          ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FittedBox(
                                child: recipe.primaryImage != null
                                    ? Image.memory(recipe.primaryImage!)
                                    : Icon(Icons.photo),
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      Container(
                          color: recipe.color != null
                              ? recipe.color
                              : Colors.black,
                          child: Text(
                            recipe.name,
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ))
          .toList();

      return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        children: <Widget>[...gridItems],
      );
    }
    return SizedBox.shrink();
  }
}
