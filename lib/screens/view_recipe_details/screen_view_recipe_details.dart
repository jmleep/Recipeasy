import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:my_recipes/data/repository/recipe_repository_interface.dart';
import 'package:my_recipes/screens/view_recipe_details/view_model/view_model_view_recipe_details.dart';
import 'package:my_recipes/screens/view_recipe_details/widgets/expansion_tile_recipe_attribute.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:my_recipes/widgets/photos/photo_preview_list.dart';
import 'package:my_recipes/widgets/tags/list_tags.dart';
import 'package:provider/provider.dart';

import '../common/view_add_edit_recipe.dart';

class ViewRecipeDetailsScreen extends ViewAddEditRecipe {
  final Recipe recipe;
  final RecipeRepository repository;

  @override
  _ViewRecipeState createState() => _ViewRecipeState();

  ViewRecipeDetailsScreen({required this.recipe, required this.repository});
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

    context.read<ViewRecipeViewModel>().init(widget.recipe, widget.repository);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (context.watch<ViewRecipeViewModel>().isLoading) {
      body = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [Center(child: CircularProgressIndicator())]);
    } else {
      body = SingleChildScrollView(
          child: Container(
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            TagList(tags: context.watch<ViewRecipeViewModel>().recipeTags),
            RecipeAttributeExpansionTile(
              items: context.watch<ViewRecipeViewModel>().recipeIngredients,
              title: 'Ingredients',
              noItemsText: 'No ingredients added',
            ),
            RecipeAttributeExpansionTile(
              title: 'Steps',
              isNumbered: true,
              items: context.watch<ViewRecipeViewModel>().recipeSteps,
              noItemsText: 'No steps added',
              key: UniqueKey(),
            )
          ],
        )),
      ));
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: RecipeAppBar(
          title: context.watch<ViewRecipeViewModel>().recipe.name,
          actions: getAppBarActions(),
        ),
        body: body);
  }
}
