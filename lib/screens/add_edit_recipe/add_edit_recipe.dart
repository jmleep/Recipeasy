import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/model/recipe.dart';
import 'package:my_recipes/util/widget_styles.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/button_primary.dart';
import 'package:my_recipes/widgets/buttons/button_primary_mini.dart';

class AddEditRecipe extends StatefulWidget {
  @override
  _AddEditRecipeState createState() => _AddEditRecipeState();
}

class _AddEditRecipeState extends State<AddEditRecipe> {
  final _ingredients = List<String>();
  final _formKey = GlobalKey<FormState>();
  var _recipeColor = Colors.orange;
  var _tempRecipeColor = Colors.orange;
  File _image;
  var _imagePath;
  final _picker = ImagePicker();
  final _nameController = TextEditingController();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: RecipeAppBar(
        title: "Add Recipe",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: ListView(shrinkWrap: true, children: [
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FlatButton(
                                  child: _image != null
                                      ? CircleAvatar(
                                          radius: 105,
                                          backgroundColor: _recipeColor,
                                          child: CircleAvatar(
                                              backgroundImage:
                                                  FileImage(_image),
                                              radius: 100.0))
                                      : CircleAvatar(
                                          radius: 105,
                                          backgroundColor: _recipeColor,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white,
                                              ),
                                              radius: 100.0),
                                        ),
                                  onPressed: getImage,
                                ),
                              ),
                            ]),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: FlatButton(
                            child: CircleAvatar(
                              backgroundColor: _recipeColor,
                              radius: 25.0,
                              child: Icon(Icons.palette,
                                  color: _recipeColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    contentPadding: const EdgeInsets.all(8.0),
                                    content: Container(
                                      child: MaterialColorPicker(
                                        onMainColorChange: (Color color) {
                                          setState(() {
                                            _tempRecipeColor = color;
                                          });
                                        },
                                        selectedColor: _recipeColor,
                                        allowShades: false,
                                        shrinkWrap: true,
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: Navigator.of(context).pop,
                                      ),
                                      FlatButton(
                                        child: Text('Select'),
                                        onPressed: () {
                                          setState(() {
                                            _recipeColor = _tempRecipeColor;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: ReusableStyleWidget.inputDecoration(
                              context, 'Recipe Name'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _ingredients.length,
                          itemBuilder: (context, index) {
                            return TextFormField(
                              autofocus: _ingredients[index].isEmpty,
                              decoration: InputDecoration(
                                  hintText: 'ingredient...',
                                  fillColor: Colors.black54),
                              initialValue: _ingredients[index],
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MiniPrimaryButton(
                          icon: Icons.add_circle_outline,
                          onButtonPress: () {
                            HapticFeedback.mediumImpact();
                            if (_ingredients.length > 0 &&
                                _ingredients[_ingredients.length - 1]
                                    .isNotEmpty) {
                              setState(() {
                                _ingredients.add('');
                              });
                            } else {
                              setState(() {
                                _ingredients.add('');
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //Spacer(),
                      ],
                    ),
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PrimaryButton(
                icon: Icons.save,
                text: 'Save',
                onButtonPress: () {
                  HapticFeedback.mediumImpact();

                  if (_formKey.currentState.validate()) {
                    List<Ingredient> userIngredients =
                        _ingredients.map((e) => Ingredient(value: e)).toList();

                    Recipe r = new Recipe(
                        name: _nameController.text,
                        notes: 'yum!',
                        meatContent: MeatContent.meat,
                        ingredients: userIngredients,
                        imagePath: _imagePath,
                        color: _recipeColor);

                    RecipeDatabaseManager.upsertRecipe(r);

                    Navigator.pop(context);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
