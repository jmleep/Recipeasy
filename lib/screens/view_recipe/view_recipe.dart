import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/database/recipe_database_manager.dart';
import 'package:my_recipes/database/recipe_photo_database_manager.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/model/recipe_photo.dart';
import 'package:my_recipes/screens/add_edit_recipe/add_edit_recipe.dart';
import 'package:my_recipes/screens/view_add_edit_recipe.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:my_recipes/widgets/photos/photo_preview_list.dart';

class ViewRecipe extends ViewAddEditRecipe {
  final Recipe recipe;

  @override
  _ViewRecipeState createState() => _ViewRecipeState();

  ViewRecipe({this.recipe});
}

class _ViewRecipeState extends ViewAddEditRecipeState<ViewRecipe> {
  List<RecipePhoto> _recipePhotos = new List<RecipePhoto>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _recipe;

  setupRecipeData() async {
    _recipe = widget.recipe;

    getRecipePhotos();
  }

  getRecipePhotos() async {
    RecipePhotoDatabaseManager.getImages(_recipe.id).then((value) {
      setState(() {
        _recipePhotos = value;
      });
    });
  }

  editRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditRecipe(
                recipe: _recipe,
              )),
    );

    getRecipePhotos();

    Recipe updatedRecipe = await RecipeDatabaseManager.getRecipe(_recipe.id);

    // Get updated recipe after edit
    setState(() {
      _recipe = updatedRecipe;
    });
  }

  List<AppBarAction> getAppBarActions() {
    return [
      new AppBarAction(
          Icon(
            Icons.edit,
            color: Theme.of(context).primaryColor,
          ),
          editRecipe),
    ];
  }

  @override
  void initState() {
    super.initState();

    setupRecipeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: RecipeAppBar(
        title: _recipe.name,
        actions: getAppBarActions(),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ActivePhoto(
                recipePhotos: _recipePhotos,
                activePhoto: this.activePhoto,
                swipeActivePhoto: swipeActivePhoto,
              ),
              PhotoPreviewList(
                  scrollController: previewScrollController,
                  recipePhotos: _recipePhotos,
                  setActivePhoto: setActivePhoto,
                  activePhoto: activePhoto),
            ],
          ),
        ),
      ),
    );
  }
}
