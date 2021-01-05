// import 'package:flutter/material.dart';
//
// class MiniPrimaryButton extends StatelessWidget {
//   final Function onButtonPress;
//   final IconData icon;
//   final String buttonText;
//
//   MiniPrimaryButton({this.onButtonPress, this.icon, this.buttonText});
//
//   Widget getIcon() {
//     if (icon != null) {
//       return Icon(
//         icon,
//         color: Colors.white,
//       );
//     }
//     return SizedBox.shrink();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FractionallySizedBox(
//       widthFactor: 0.5,
//       child: FlatButton(
//         color: Theme.of(context).primaryColor,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//             side: BorderSide(color: Theme.of(context).primaryColor)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             getIcon(),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 buttonText,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//         onPressed: onButtonPress,
//       ),
//     );
//   }
// }
