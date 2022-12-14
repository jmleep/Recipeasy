import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/data/model/recipe_ingredient.dart';
import 'package:my_recipes/data/model/recipe.dart';
import 'package:my_recipes/data/repository/recipe_repository_interface.dart';
import 'package:my_recipes/screens/add_edit_recipe/view_model/view_model_add_edit_recipe.dart';
import 'package:my_recipes/screens/add_edit_recipe/widgets/add_tag.dart';
import 'package:my_recipes/screens/add_edit_recipe/widgets/edit_recipe_attribute.dart';
import 'package:my_recipes/screens/add_edit_recipe/widgets/text_form_field_recipe_name.dart';
import 'package:my_recipes/widgets/photos/active_photo.dart';
import 'package:provider/provider.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/photos/photo_preview_list.dart';
import '../../data/model/recipe_step.dart';
import '../../widgets/tags/list_tags.dart';
import '../common/view_add_edit_recipe.dart';

class AddEditRecipeScreen extends ViewAddEditRecipe {
  final Recipe? recipe;
  final RecipeRepository repository;

  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();

  AddEditRecipeScreen({this.recipe, required this.repository});
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

  setupTextFieldControllers(
      List<RecipeIngredient> ingredients, List<RecipeStep> steps) {
    context.watch<AddEditRecipeViewModel>().recipeIngredientControllers = [];
    context.watch<AddEditRecipeViewModel>().recipeStepControllers = [];
    ingredients.forEach((element) {
      var controller = new TextEditingController();
      controller.value = TextEditingValue(text: element.value ?? '');
      context
          .watch<AddEditRecipeViewModel>()
          .recipeIngredientControllers
          .add(controller);
    });

    steps.forEach((element) {
      var controller = new TextEditingController();
      controller.value = TextEditingValue(text: element.value ?? '');
      context
          .watch<AddEditRecipeViewModel>()
          .recipeStepControllers
          .add(controller);
    });
  }

  @override
  void initState() {
    super.initState();

    context
        .read<AddEditRecipeViewModel>()
        .init(widget.recipe, widget.repository);
  }

  @override
  Widget build(BuildContext context) {
    var ingredients = context.watch<AddEditRecipeViewModel>().recipeIngredients;
    var steps = context.watch<AddEditRecipeViewModel>().recipeSteps;
    var tempRecipePhotos =
        context.watch<AddEditRecipeViewModel>().tempRecipePhotos;
    var tags = context.watch<AddEditRecipeViewModel>().recipeTags;

    setupTextFieldControllers(ingredients, steps);

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
          controller: context.watch<AddEditRecipeViewModel>().scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RecipeNameTextFormField(
                formKey: context.watch<AddEditRecipeViewModel>().formKey,
                recipeNameController: context
                    .watch<AddEditRecipeViewModel>()
                    .recipeNameController,
              ),
              TagList(tags: tags),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: AddTag(),
              ),
              SizedBox(
                height: 20,
              ),
              ActivePhoto(
                  recipePhotos: tempRecipePhotos,
                  activePhoto: activePhoto,
                  addImageToTempListOfPhotos: context
                      .read<AddEditRecipeViewModel>()
                      .addImageToTempListOfPhotos,
                  swipeActivePhoto: swipeActivePhoto,
                  deletePhoto: (int? index) => context
                      .read<AddEditRecipeViewModel>()
                      .deletePhoto(index, activePhoto, setActivePhoto),
                  setPrimaryPhoto: () => context
                      .read<AddEditRecipeViewModel>()
                      .setPrimaryPhoto(activePhoto)),
              PhotoPreviewList(
                  scrollController: previewScrollController,
                  recipePhotos: tempRecipePhotos,
                  setActivePhoto: () => context
                      .read<AddEditRecipeViewModel>()
                      .setPrimaryPhoto(activePhoto),
                  activePhoto: activePhoto,
                  addPhoto: () => context
                      .read<AddEditRecipeViewModel>()
                      .addImageToTempListOfPhotos(
                          previewScrollController, setActivePhoto)),
              EditRecipeAttribute(
                title: 'Ingredients',
                inputHint: 'Add an ingredient',
                items: ingredients,
                controllers: context
                    .watch<AddEditRecipeViewModel>()
                    .recipeIngredientControllers,
                addItem: context.read<AddEditRecipeViewModel>().addIngredient,
                updateItem:
                    context.read<AddEditRecipeViewModel>().updateIngredient,
                removeItem:
                    context.read<AddEditRecipeViewModel>().removeIngredient,
              ),
              SizedBox(
                height: 20,
              ),
              EditRecipeAttribute(
                title: 'Steps',
                inputHint: 'Add step',
                items: steps,
                isNumbered: true,
                controllers: context
                    .watch<AddEditRecipeViewModel>()
                    .recipeStepControllers,
                addItem: context.read<AddEditRecipeViewModel>().addStep,
                updateItem: context.read<AddEditRecipeViewModel>().updateStep,
                removeItem: context.read<AddEditRecipeViewModel>().removeStep,
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
