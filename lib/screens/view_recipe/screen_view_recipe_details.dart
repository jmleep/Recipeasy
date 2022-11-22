import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:my_recipes/widgets/photos/photo_preview_list.dart';

import '../screen_add_edit_recipe.dart';
import '../common/view_add_edit_recipe.dart';
import 'list_item_ingredient.dart';

class ViewRecipeDetailsScreen extends ViewAddEditRecipe {
  final Recipe recipe;

  @override
  _ViewRecipeState createState() => _ViewRecipeState();

  ViewRecipeDetailsScreen({this.recipe});
}

class _ViewRecipeState extends ViewAddEditRecipeState<ViewRecipeDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _recipe;
  var _isLoading = false;
  var _recipeImages = <RecipePhoto>[];
  var _recipeIngredients = <Ingredient>[];

  getRecipeData() async {
    setState(() => _isLoading = true);

    var recipeImages = RecipePhotoDatabaseManager.getImages(_recipe.id);
    var recipeIngredients = RecipeDatabaseManager.getIngredients(_recipe.id);

    var results = await Future.wait([recipeImages, recipeIngredients]);

    setState(() {
      _recipeImages.addAll(results[0] as List<RecipePhoto>);
      _recipeIngredients.addAll(results[1] as List<Ingredient>);
      _isLoading = false;
    });
  }

  editRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditRecipeScreen(
                recipe: _recipe,
              )),
    );

    // await getRecipePhotos();

    Recipe updatedRecipe = await RecipeDatabaseManager.getRecipe(_recipe.id);

    setState(() {
      _recipe = updatedRecipe;
      _recipeImages = [];
    });

    getRecipeData();
  }

  List<AppBarAction> getAppBarActions() {
    return [
      new AppBarAction(
          Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.primary,
          ),
          editRecipe),
    ];
  }

  @override
  void initState() {
    super.initState();

    this._recipe = widget.recipe;
    getRecipeData();
  }

  Widget getBody() {
    if (this._isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    var items = ['123', '123', '123'];

    return Container(
      height: 900,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ActivePhoto(
            recipePhotos: _recipeImages,
            activePhoto: this.activePhoto,
            swipeActivePhoto: swipeActivePhoto,
          ),
          PhotoPreviewList(
              scrollController: previewScrollController,
              recipePhotos: _recipeImages,
              setActivePhoto: setActivePhoto,
              activePhoto: this.activePhoto),
          ExpansionTile(
            title: Text('Ingredients', style: TextStyle(fontSize: 25)),
            initiallyExpanded: _recipeIngredients.length != 0,
            children: [
              _recipeIngredients.length == 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Text("No ingredients added"))
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _recipeIngredients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return IngredientListItem(
                            item: _recipeIngredients[index],
                            showDivider: index != items.length - 1);
                      })
            ],
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: RecipeAppBar(
          title: _recipe?.name ?? 'Loading...',
          actions: getAppBarActions(),
        ),
        body: SingleChildScrollView(child: getBody()));
  }
}
