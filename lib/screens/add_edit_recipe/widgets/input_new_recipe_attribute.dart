import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/theme/widget_styles.dart';
import 'package:my_recipes/widgets/buttons/button_recipeasy.dart';

class NewRecipeAttributeInput extends StatefulWidget {
  final dynamic Function(String) addAttribute;
  final String inputHint;
  final bool isNumbered;
  final int activeIndex;

  const NewRecipeAttributeInput(
      {required Key key,
      required this.addAttribute,
      required this.inputHint,
      required this.isNumbered,
      required this.activeIndex})
      : super(key: key);

  @override
  State<NewRecipeAttributeInput> createState() =>
      _NewRecipeAttributeInputState();
}

class _NewRecipeAttributeInputState extends State<NewRecipeAttributeInput> {
  var _textFieldController = TextEditingController();

  addIngredient() {
    HapticFeedback.mediumImpact();
    widget.addAttribute(_textFieldController.text);
    _textFieldController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var inputHintText = widget.inputHint;
    if (widget.isNumbered) {
      inputHintText += ' ${widget.activeIndex + 1}';
    }

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
                          context, null, inputHintText)))),
          Container(
              padding: EdgeInsets.only(right: 10, top: 5),
              child: RoundedButton(
                  buttonText: 'Add', onPressed: () => addIngredient()))
        ]);
  }
}
