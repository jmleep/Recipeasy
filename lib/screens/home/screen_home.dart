import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/screens/home/view_model/view_model_home.dart';
import 'package:my_recipes/screens/home/widgets/grid_recipe.dart';
import 'package:my_recipes/screens/home/widgets/layout_and_search.dart';
import 'package:my_recipes/screens/home/widgets/list_recipe.dart';
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
    Widget body;

    if (!context.watch<HomeViewModel>().isAnyRecipePresent) {
      body = Center(
          child: Text(
        'Click "New Recipe" to add your first recipe!',
        style: TextStyle(fontSize: 16),
      ));
    } else {
      body = Column(
        children: [
          LayoutAndSearch(),
          context.watch<HomeViewModel>().isSearchLoading
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: CircularProgressIndicator(),
                ))
              : RecipeItems(scaffoldKey: _scaffoldKey),
        ],
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

class RecipeItems extends StatelessWidget {
  const RecipeItems({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    if (context.watch<HomeViewModel>().isLoading) {
      return CircularProgressIndicator();
    }

    if (context.watch<HomeViewModel>().isGrid) {
      return Flexible(
        child: RecipeGrid(
          scaffoldKey: _scaffoldKey,
        ),
      );
    } else {
      return Flexible(child: RecipeList());
    }
  }
}
