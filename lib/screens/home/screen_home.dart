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
                      ArrangementListItem('2 Column Grid', Icons.grid_view, () {
                        context.read<HomeViewModel>().setGridColumnCount(2);
                      }),
                      ArrangementListItem('3 Column Grid', Icons.grid_on, () {
                        context.read<HomeViewModel>().setGridColumnCount(3);
                      }),
                      ArrangementListItem('List', Icons.format_list_bulleted,
                          () {
                        context.read<HomeViewModel>().setIsGrid(false);
                      })
                    ],
                  );
                },
                context: context,
              );
            },
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, bottom: 5),
                child: Icon(
                  Icons.sort,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
          ),
          RecipeItems(scaffoldKey: _scaffoldKey),
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
    if (context.watch<HomeViewModel>().isGrid) {
      return Flexible(
        child: RecipeGrid(
          scaffoldKey: _scaffoldKey,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              bool hasImage =
                  context.watch<HomeViewModel>().recipes[index].primaryImage !=
                      null;
              return ListTile(
                leading: hasImage
                    ? AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FittedBox(
                                child: Image.memory(context
                                    .watch<HomeViewModel>()
                                    .recipes[index]
                                    .primaryImage!),
                                fit: BoxFit.cover),
                          ),
                        ),
                      )
                    : null,
                title: Padding(
                  padding:
                      hasImage ? EdgeInsets.zero : EdgeInsets.only(left: 5),
                  child:
                      Text(context.watch<HomeViewModel>().recipes[index].name),
                ),
                onTap: () {
                  context.read<HomeViewModel>().navigateTo(
                      context, context.read<HomeViewModel>().recipes[index]);
                },
              );
            },
            separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            itemCount: context.watch<HomeViewModel>().recipes.length),
      );
    }
  }
}
