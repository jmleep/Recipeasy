import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/screens/home/grid.dart';

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
        primaryColor: Colors.green[500],
        backgroundColor: Colors.white,
        accentColor: Colors.green[700],
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.green[500],
        backgroundColor: Colors.black12,
        accentColor: Colors.green[700],
        brightness: Brightness.dark,
      ),
      home: HomeGrid(),
    );
  }
}

