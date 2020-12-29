import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipes/util/widget_styles.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/button_color_picker.dart';
import 'package:my_recipes/widgets/buttons/button_image_picker.dart';
import 'package:my_recipes/widgets/buttons/button_primary_mini.dart';
import 'package:my_recipes/widgets/buttons/button_save_recipe.dart';

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

  void setColor(BuildContext context) {
    setState(() {
      _recipeColor = _tempRecipeColor;
    });
    Navigator.of(context).pop();
  }

  void setTempColor(Color color) {
    setState(() {
      _tempRecipeColor = color;
    });
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
                                child: ImagePickerButton(
                                    recipeColor: _recipeColor,
                                    getImage: this.getImage,
                                    image: _image),
                              ),
                            ]),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: ColorPickerButton(
                              recipeColor: _recipeColor,
                              setColor: this.setColor,
                              setTempColor: this.setTempColor),
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
            child: SaveRecipeButton(
                formKey: _formKey,
                ingredients: _ingredients,
                nameController: _nameController,
                imagePath: _imagePath,
                recipeColor: _recipeColor),
          ),
        ],
      ),
    );
  }
}
