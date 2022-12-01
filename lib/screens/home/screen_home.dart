import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/screens/home/view_model/view_model_home.dart';
import 'package:my_recipes/screens/home/widgets/grid_recipe.dart';
import 'package:my_recipes/screens/home/widgets/list_home_view_arrangement.dart';
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
      body = Column(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                builder: (context) {
                  return HomeViewArrangementList(
                    items: [
                      ArrangementListItem('Grid', Icons.grid_on, () {
                        print('tap grid');
                      }),
                      ArrangementListItem('List', Icons.format_list_bulleted,
                          () {
                        print('tap list');
                      })
                    ],
                  );
                },
                context: context,
              );
            },
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.sort,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
          ),
          Flexible(
            child: RecipeGrid(
              scaffoldKey: _scaffoldKey,
            ),
          ),
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
