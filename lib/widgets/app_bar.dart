import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool allowBack;
  final List<AppBarAction> actions;

  RecipeAppBar({this.title, this.allowBack = true, this.actions});

  List<Widget> getActions() {
    List<Widget> actionButtons = [];

    if (this.actions != null) {
      this.actions.forEach((element) {
        actionButtons.add(Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(onTap: element.callback, child: element.icon),
        ));
      });
    }

    return actionButtons;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          allowBack ? BackButton(color: Theme.of(context).primaryColor) : null,
      actions: <Widget>[...getActions()],
      title: Text(title,
          style: GoogleFonts.pacifico(
            color: Theme.of(context).primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          )),
      elevation: 0.0,
      centerTitle: true,
      brightness: Brightness.dark,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarAction {
  Icon icon;
  Function callback;

  AppBarAction(this.icon, this.callback);
}
