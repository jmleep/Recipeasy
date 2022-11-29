import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/screens/home/view_model/view_model_home.dart';
import 'package:my_recipes/screens/home/widgets/grid_recipe.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/button_add_recipe_floating_action.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<HomeViewModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<HomeViewModel>().isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    Widget body;

    if (context.watch<HomeViewModel>().recipes.length == 0) {
      body = Center(
          child: Text(
        'Click "New Recipe" to add your first recipe!',
        style: TextStyle(fontSize: 16),
      ));
    } else {
      body = RecipeGrid(
        scaffoldKey: _scaffoldKey,
      );
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: RecipeAppBar(
          title: 'Recipeasy', //'My Recipes 🥘',
          allowBack: false,
          actions: [
            AppBarAction(
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                () => context.read<HomeViewModel>().navigateToSettings(context))
          ],
        ),
        body: body,
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: AddRecipeFloatingActionButton(
          key: UniqueKey(),
          onPressAddRecipeFAB: context.read<HomeViewModel>().navigateTo,
        ));
  }
}
