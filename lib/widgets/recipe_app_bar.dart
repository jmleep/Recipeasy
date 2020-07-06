import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool allowBack;

  RecipeAppBar({this.title, this.allowBack = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: allowBack ? BackButton(
     color: Theme.of(context).primaryColor
   ) : null, 
        title: Text(title,
            style: GoogleFonts.pacifico(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              )),
        elevation: 0.0,
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
