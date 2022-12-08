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
    var gridColumnCount = context.watch<HomeViewModel>().gridColumnCount;
    var textSize = gridColumnCount >= 3 ? 24.0 : 36.0;

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
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary
                              ])),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 2,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: recipe.primaryImage != null
                                      ? FittedBox(
                                          child: Image.memory(
                                              recipe.primaryImage!),
                                          fit: BoxFit.cover)
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(recipe.name,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: textSize,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary)),
                                              ),
                                            ),
                                          ],
                                        ),
                                )),
                          ),
                          if (recipe.primaryImage != null)
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  recipe.name,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
          .toList();

      return GridView.count(
        crossAxisCount: gridColumnCount,
        mainAxisSpacing: 10,
        children: <Widget>[...gridItems],
      );
    }
    return SizedBox.shrink();
  }
}
