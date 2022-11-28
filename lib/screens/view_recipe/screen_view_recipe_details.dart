import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:my_recipes/screens/view_recipe/view_model_view_recipe.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:my_recipes/widgets/photos/photo_preview_list.dart';
import 'package:provider/provider.dart';

import '../common/view_add_edit_recipe.dart';
import 'list_item_ingredient.dart';

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

  Widget getBody(ViewRecipeViewModel vm) {
    if (vm.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 900,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ActivePhoto(
            recipePhotos: vm.recipeImages,
            activePhoto: activePhoto,
            swipeActivePhoto: swipeActivePhoto,
          ),
          PhotoPreviewList(
              scrollController: previewScrollController,
              recipePhotos: vm.recipeImages,
              setActivePhoto: setActivePhoto,
              activePhoto: activePhoto),
          ExpansionTile(
            title: Text('Ingredients', style: TextStyle(fontSize: 25)),
            initiallyExpanded: vm.recipeIngredients.length != 0,
            children: [
              vm.recipeIngredients.length == 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Text("No ingredients added"))
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: vm.recipeIngredients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return IngredientListItem(
                            key: UniqueKey(),
                            item: vm.recipeIngredients[index],
                            showDivider:
                                index != vm.recipeIngredients.length - 1);
                      })
            ],
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewRecipeViewModel>(
        builder: (context, vm, child) => Scaffold(
            key: _scaffoldKey,
            appBar: RecipeAppBar(
              title: vm.recipe.name,
              actions: getAppBarActions(),
            ),
            body: SingleChildScrollView(child: getBody(vm))));
  }
}
