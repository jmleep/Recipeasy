// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:my_recipes/data/model/recipe.dart';
// import 'package:my_recipes/util/utils.dart';
//
// class RecipeListItem extends StatelessWidget {
//   final Recipe recipe;
//   final Function onPressed;
//
//   const RecipeListItem({Key key, this.recipe, this.onPressed}) : super(key: key);
//
//   Widget getImage() {
//     return Expanded(
//       child: FutureBuilder(
//           future: Utils.loadFileFromPath(recipe.primaryPhotoPath),
//           builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//             Widget response;
//
//             if (snapshot.data != null) {
//               response = Image(
//                 image: FileImage(snapshot.data),
//               );
//             } else {
//               response = Icon(Icons.photo);
//             }
//
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(4.0),
//               child: FittedBox(
//                 child: response,
//                 fit: BoxFit.fitWidth,
//               ),
//             );
//           }),
//     );
//   }
//
//   Widget getText() {
//     return Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: Text(
//           recipe.name,
//           style: TextStyle(
//               color: recipe.color.computeLuminance() > 0.5
//                   ? Colors.black
//                   : Colors.white,
//               fontSize: 20),
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         onPressed(recipe);
//       },
//       child: Container(
//         height: 200,
//         width: double.infinity,
//         child: Card(
//           color: recipe.color,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[getImage(), getText()],
//           ),
//         ),
//       ),
//     );
//   }
// }
