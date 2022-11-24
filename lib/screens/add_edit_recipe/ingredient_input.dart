import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/model/ingredient.dart';
import 'package:my_recipes/widgets/buttons/button_recipeasy.dart';

class IngredientInput extends StatefulWidget {
  final dynamic Function(Ingredient) addIngredient;
  const IngredientInput({Key key, this.addIngredient}) : super(key: key);

  @override
  State<IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends State<IngredientInput> {
  var _textFieldController = TextEditingController();

  addIngredient() {
    HapticFeedback.mediumImpact();
    widget.addIngredient(Ingredient(value: _textFieldController.text));
    _textFieldController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                      controller: _textFieldController,
                      //onSubmitted: () {},
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          label: Text('Enter an ingredient'))))),
          RoundedButton(buttonText: 'Add', onPressed: () => addIngredient())
        ]);
  }
}
