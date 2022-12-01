import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/theme/widget_styles.dart';

class RecipeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool allowBack;
  final List<AppBarAction>? actions;

  RecipeAppBar({required this.title, this.allowBack = true, this.actions});

  List<Widget> getActions() {
    List<Widget> actionButtons = [];

    if (this.actions != null) {
      this.actions?.forEach((element) {
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
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.background,
          statusBarIconBrightness:
              Theme.of(context).colorScheme.brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light),
      leading: allowBack
          ? BackButton(color: Theme.of(context).colorScheme.primary)
          : null,
      actions: <Widget>[...getActions()],
      title: Text(title, style: ReusableStyleWidget.appBarTextStyle(context)),
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarAction {
  Icon icon;
  Function()? callback;

  AppBarAction(this.icon, this.callback);
}
