import 'package:flutter/material.dart';
import 'package:my_recipes/database/RecipeDataManager.dart';
import 'model/recipe.dart';
import 'routes/add_recipe_route.dart';

void main() {
  runApp(MyRecipeApp());
}

class MyRecipeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Recipes',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.deepOrange,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        accentColor: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      home: Main(title: 'My Recipes'),
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: RecipeDatabaseManager.allRecipes(),
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        Widget child;
        if (snapshot.hasData && snapshot.data.length > 0) {
          child = ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                var recipeName = snapshot.data[index].name;
                return ListTile(
                  title: Text('$recipeName'),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: snapshot.data.length);
        } else {
          child = Text(
            'Add a recipe!',
          );
        }

        return Scaffold(
          appBar: AppBar(
              title: Text(widget.title,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 30)),
              elevation: 0.0,
              centerTitle: true,
              brightness: Brightness.dark),
          body: Center(child: child),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
            tooltip: 'Increment',
            icon: Icon(Icons.note_add),
            label: Text('New Recipe'),
          ),
        );
      },
    );
  }
}
