import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/recipe.dart';

class AddRecipeFloatingActionButton extends StatelessWidget {
  final Function(BuildContext, Recipe?) onPressAddRecipeFAB;

  const AddRecipeFloatingActionButton(
      {required Key key, required this.onPressAddRecipeFAB})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        this.onPressAddRecipeFAB(context, null);
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icon(
        Icons.note_add,
        color: Colors.white,
      ),
      label: Text(
        'New Recipe',
        style: GoogleFonts.pacifico(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
