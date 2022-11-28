import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/theme/widget_styles.dart';
import 'package:my_recipes/widgets/buttons/button_recipeasy.dart';

class IngredientInput extends StatefulWidget {
  final dynamic Function(String) addIngredient;
  const IngredientInput({required Key key, required this.addIngredient})
      : super(key: key);

  @override
  State<IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends State<IngredientInput> {
  var _textFieldController = TextEditingController();

  addIngredient() {
    HapticFeedback.mediumImpact();
    widget.addIngredient(_textFieldController.text);
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
                      onSubmitted: (value) {
                        addIngredient();
                      },
                      decoration: ReusableStyleWidget.inputThemeUnderlineBorder(
                          context, null, 'Enter an ingredient')))),
          Container(
              padding: EdgeInsets.only(right: 10, top: 5),
              child: RoundedButton(
                  buttonText: 'Add', onPressed: () => addIngredient()))
        ]);
  }
}
