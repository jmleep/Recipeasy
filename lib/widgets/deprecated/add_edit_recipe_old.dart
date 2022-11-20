// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:my_recipes/database/recipe_database_manager.dart';
// import 'package:my_recipes/model/ingredient.dart';
// import 'package:my_recipes/model/recipe.dart';
// import 'package:my_recipes/util/widget_styles.dart';
// import 'package:my_recipes/widgets/app_bar.dart';
// import 'package:my_recipes/widgets/buttons/button_color_picker.dart';
// import 'file:///C:/Users/Jordan/dev/my_recipes/lib/widgets/deprecated/button_image_picker.dart';
// import 'file:///C:/Users/Jordan/dev/my_recipes/lib/widgets/deprecated/button_primary_mini.dart';
// import 'file:///C:/Users/Jordan/dev/my_recipes/lib/widgets/deprecated/button_save_recipe.dart';
//
// class AddEditRecipeOld extends StatefulWidget {
//   final Recipe recipe;
//
//   AddEditRecipeOld({Key key, this.recipe}) : super(key: key);
//
//   @override
//   _AddEditRecipeOldState createState() => _AddEditRecipeOldState();
// }
//
// class _AddEditRecipeOldState extends State<AddEditRecipeOld> {
//   Future<List<Ingredient>> existingIngredients;
//   var _ingredients = List<Ingredient>();
//   final _formKey = GlobalKey<FormState>();
//   var _recipeColor = Colors.orange;
//   var _tempRecipeColor = Colors.orange;
//   File _image;
//   var _imagePath;
//   final _picker = ImagePicker();
//   final _nameController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.recipe != null) {
//       existingIngredients =
//           RecipeDatabaseManager.getIngredients(widget.recipe.id);
//     }
//   }
//
//   Future getImage() async {
//     final pickedFile = await _picker.getImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _imagePath = pickedFile.path;
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   void setColor(BuildContext context) {
//     setState(() {
//       _recipeColor = _tempRecipeColor;
//     });
//     Navigator.of(context).pop();
//   }
//
//   void setTempColor(Color color) {
//     setState(() {
//       _tempRecipeColor = color;
//     });
//   }
//
//   Widget displayIngredients(
//       BuildContext context, AsyncSnapshot<List<Ingredient>> snapshot) {
//     Widget view = Text('No ingredients');
//     if (snapshot.hasData && snapshot.data.length > 0) {
//       // view = ListView.builder(
//       //     itemBuilder: (BuildContext context, int index) {
//       //       var ingredient = snapshot.data[index].value;
//       //       return TextFormField(initialValue: ingredient,);
//       //     });
//     }
//
//     return view;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).accentColor,
//       appBar: RecipeAppBar(
//         title: "Add Recipe",
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Flexible(
//             child: ListView(shrinkWrap: true, children: [
//               Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: ImagePickerButton(
//                                     recipeColor: _recipeColor,
//                                     getImage: this.getImage,
//                                     image: _image),
//                               ),
//                             ]),
//                         Container(
//                           alignment: Alignment.bottomRight,
//                           child: ColorPickerButton(
//                               recipeColor: _recipeColor,
//                               setColor: this.setColor,
//                               setTempColor: this.setTempColor),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: ReusableStyleWidget.inputDecoration(
//                               context, 'Recipe Name'),
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Please enter some text';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         FutureBuilder<List<Ingredient>>(
//                           future: existingIngredients,
//                           builder: (BuildContext context,
//                               AsyncSnapshot<List<Ingredient>> snapshot) {
//                             return displayIngredients(context, snapshot);
//                           },
//                         ),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _ingredients.length,
//                           itemBuilder: (context, index) {
//                             return TextFormField(
//                               autofocus: _ingredients[index].value.isEmpty,
//                               decoration: InputDecoration(
//                                   hintText: 'ingredient...',
//                                   fillColor: Colors.black54),
//                               initialValue: _ingredients[index].value,
//                             );
//                           },
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         MiniPrimaryButton(
//                           icon: Icons.add_circle_outline,
//                           buttonText: 'Add Ingredient',
//                           onButtonPress: () {
//                             HapticFeedback.mediumImpact();
//                             if (_ingredients.length > 0 &&
//                                 _ingredients[_ingredients.length - 1]
//                                     .value
//                                     .isNotEmpty) {
//                               setState(() {
//                                 _ingredients.add(new Ingredient(value: ''));
//                               });
//                             } else {
//                               setState(() {
//                                 _ingredients.add(new Ingredient(value: ''));
//                               });
//                             }
//                           },
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         //Spacer(),
//                       ],
//                     ),
//                   )),
//             ]),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SaveRecipeButton(
//                 formKey: _formKey,
//                 ingredients: _ingredients,
//                 nameController: _nameController,
//                 imagePath: _imagePath,
//                 recipeColor: _recipeColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
