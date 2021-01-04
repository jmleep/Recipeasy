import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/screens/add_edit_recipe/add_edit_recipe2.dart';

Future<File> _getFile(String filename) async {
  File f = new File(filename);
  return f;
}

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;

  const RecipeListItem({Key key, this.recipe}) : super(key: key);

  Widget getImage() {
    return Expanded(
      child: FutureBuilder(
          future: _getFile(recipe.primaryImagePath),
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            Widget response;

            if (snapshot.data != null) {
              response = Image(
                image: FileImage(snapshot.data),
              );
            } else {
              response = Icon(Icons.photo);
            }

            return ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: FittedBox(
                child: response,
                fit: BoxFit.fitWidth,
              ),
            );
          }),
    );
  }

  Widget getText() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          recipe.name,
          style: TextStyle(
              color: recipe.color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              fontSize: 20),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddEditRecipe2(
                    recipe: recipe,
                  )),
        );
      },
      child: Container(
        height: 200,
        width: double.infinity,
        child: Card(
          color: recipe.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[getImage(), getText()],
          ),
        ),
      ),
    );
  }
}
