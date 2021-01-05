// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ImagePickerButton extends StatelessWidget {
//   const ImagePickerButton(
//       {Key key,
//       @required MaterialColor recipeColor,
//       @required File image,
//       @required Function getImage})
//       : _recipeColor = recipeColor,
//         _image = image,
//         getImage = getImage,
//         super(key: key);
//
//   final MaterialColor _recipeColor;
//   final File _image;
//   final Function getImage;
//
//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       child: _image != null
//           ? CircleAvatar(
//               radius: 105,
//               backgroundColor: _recipeColor,
//               child: CircleAvatar(
//                   backgroundImage: FileImage(_image), radius: 100.0))
//           : CircleAvatar(
//               radius: 105,
//               backgroundColor: _recipeColor,
//               child: CircleAvatar(
//                   backgroundColor: Colors.grey,
//                   child: Icon(
//                     Icons.add_a_photo,
//                     color: Colors.white,
//                   ),
//                   radius: 100.0),
//             ),
//       onPressed: getImage,
//     );
//   }
// }
