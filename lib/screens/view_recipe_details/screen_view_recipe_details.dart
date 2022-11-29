import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:my_recipes/screens/view_recipe_details/view_model/view_model_view_recipe_details.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:my_recipes/widgets/photos/photo_preview_list.dart';
import 'package:provider/provider.dart';

import '../common/view_add_edit_recipe.dart';
import 'widgets/expansion_tile_ingredients.dart';

class ViewRecipeDetailsScreen extends ViewAddEditRecipe {
  final Recipe recipe;

  @override
  _ViewRecipeState createState() => _ViewRecipeState();

  ViewRecipeDetailsScreen({required this.recipe});
}

class _ViewRecipeState extends ViewAddEditRecipeState<ViewRecipeDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<AppBarAction> getAppBarActions() {
    return [
      new AppBarAction(
          Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.primary,
          ),
          () => Provider.of<ViewRecipeViewModel>(context, listen: false)
              .editRecipe(context)),
    ];
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ViewRecipeViewModel>(context, listen: false)
        .init(widget.recipe);
  }

  Widget getBody() {
    if (context.watch<ViewRecipeViewModel>().isLoading) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [CircularProgressIndicator()]);
    }

    return Container(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ActivePhoto(
            recipePhotos: context.watch<ViewRecipeViewModel>().recipeImages,
            activePhoto: activePhoto,
            swipeActivePhoto: swipeActivePhoto,
          ),
          PhotoPreviewList(
              scrollController: previewScrollController,
              recipePhotos: context.watch<ViewRecipeViewModel>().recipeImages,
              setActivePhoto: setActivePhoto,
              activePhoto: activePhoto),
          IngredientsExpansionTile()
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: RecipeAppBar(
          title: context.watch<ViewRecipeViewModel>().recipe.name,
          actions: getAppBarActions(),
        ),
        body: SingleChildScrollView(child: getBody()));
  }
}
