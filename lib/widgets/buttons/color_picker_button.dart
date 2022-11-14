import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton(
      {Key key,
      @required MaterialColor recipeColor,
      @required Function setTempColor,
      @required Function setColor})
      : _recipeColor = recipeColor,
        setTempColor = setTempColor,
        setColor = setColor,
        super(key: key);

  final MaterialColor _recipeColor;
  final Function setTempColor;
  final Function setColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: CircleAvatar(
        backgroundColor: _recipeColor,
        radius: 25.0,
        child: Icon(Icons.palette,
            color: _recipeColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              contentPadding: const EdgeInsets.all(8.0),
              content: Container(
                child: MaterialColorPicker(
                  onMainColorChange: (Color color) {
                    setTempColor(color);
                  },
                  selectedColor: _recipeColor,
                  allowShades: false,
                  shrinkWrap: true,
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: Navigator.of(context).pop,
                ),
                TextButton(
                  child: Text('Select'),
                  onPressed: () {
                    setColor(context);
                  },
                ),
              ],
            ));
      },
    );
  }
}
