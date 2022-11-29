import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/ingredient.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:my_recipes/screens/add_edit_recipe/view_model/view_model_add_edit_recipe.dart';
import 'package:my_recipes/screens/add_edit_recipe/widgets/list_view_edit_ingredient.dart';
import 'package:my_recipes/screens/add_edit_recipe/widgets/text_form_field_recipe_name.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:provider/provider.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/photos/photo_preview_list.dart';
import '../common/view_add_edit_recipe.dart';
import 'widgets/input_new_ingredient.dart';

class AddEditRecipeScreen extends ViewAddEditRecipe {
  final Recipe? recipe;

  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();

  AddEditRecipeScreen({this.recipe});
}

class _AddEditRecipeState extends ViewAddEditRecipeState<AddEditRecipeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<AppBarAction> getAppBarActions() {
    return [
      new AppBarAction(
          Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.primary,
          ),
          () => context.read<AddEditRecipeViewModel>().saveRecipe(context))
    ];
  }

  @override
  void initState() {
    super.initState();

    context.read<AddEditRecipeViewModel>().init(widget.recipe);
  }

  @override
  Widget build(BuildContext context) {
    var ingredients = context.watch<AddEditRecipeViewModel>().recipeIngredients;
    context.watch<AddEditRecipeViewModel>().recipeIngredientControllers = [];
    ingredients.forEach((element) {
      var controller = new TextEditingController();
      controller.value = TextEditingValue(text: element.value ?? '');
      context
          .watch<AddEditRecipeViewModel>()
          .recipeIngredientControllers
          .add(controller);
    });

    return WillPopScope(
        onWillPop: () =>
            context.read<AddEditRecipeViewModel>().onPressBackButton(context),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: RecipeAppBar(
            title: context.watch<AddEditRecipeViewModel>().getTitle(),
            actions: getAppBarActions(),
          ),
          body: SingleChildScrollView(
            controller:
                context.watch<AddEditRecipeViewModel>().scrollController,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RecipeNameTextFormField(
                      formKey: context.watch<AddEditRecipeViewModel>().formKey,
                      recipeNameController: context
                          .watch<AddEditRecipeViewModel>()
                          .recipeNameController,
                    ),
                    ActivePhoto(
                        recipePhotos: context
                            .watch<AddEditRecipeViewModel>()
                            .tempRecipePhotos,
                        activePhoto: activePhoto,
                        addImageToTempListOfPhotos: context
                            .read<AddEditRecipeViewModel>()
                            .addImageToTempListOfPhotos,
                        swipeActivePhoto: swipeActivePhoto,
                        deletePhoto: (int? index) => context
                            .read<AddEditRecipeViewModel>()
                            .deletePhoto(index, activePhoto),
                        setPrimaryPhoto: () => context
                            .read<AddEditRecipeViewModel>()
                            .setPrimaryPhoto(activePhoto)),
                    PhotoPreviewList(
                        scrollController: previewScrollController,
                        recipePhotos: context
                            .watch<AddEditRecipeViewModel>()
                            .tempRecipePhotos,
                        setActivePhoto: () => context
                            .read<AddEditRecipeViewModel>()
                            .setPrimaryPhoto(activePhoto),
                        activePhoto: activePhoto,
                        addPhoto: () => context
                            .read<AddEditRecipeViewModel>()
                            .addImageToTempListOfPhotos(
                                previewScrollController, setActivePhoto)),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ingredients',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    EditIngredientsListView(
                      key: UniqueKey(),
                      ingredients: context
                          .watch<AddEditRecipeViewModel>()
                          .recipeIngredients,
                      controllers: context
                          .watch<AddEditRecipeViewModel>()
                          .recipeIngredientControllers,
                      removeIngredient: (int i) => context
                          .read<AddEditRecipeViewModel>()
                          .removeIngredient(i),
                      updateIngredient: (String text, Ingredient i) => context
                          .read<AddEditRecipeViewModel>()
                          .updateIngredient(text, i),
                    ),
                    NewIngredientInput(
                      addIngredient: (String i) => context
                          .read<AddEditRecipeViewModel>()
                          .addIngredient(i),
                      key: UniqueKey(),
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
