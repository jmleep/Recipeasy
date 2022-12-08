import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/recipe_tag.dart';

class AddEditTagDialog extends StatelessWidget {
  final RecipeTag? tag;
  final TextEditingController textEditingController = TextEditingController();
  final Function(RecipeTag?, String) upsertTag;

  AddEditTagDialog({Key? key, this.tag, required this.upsertTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isEditMode = tag != null;

    var title = isEditMode ? 'Edit ${tag?.value}' : 'Add tag';

    return AlertDialog(
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.background,
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Text(
                'Use tags to easily search or categorize recipes by things like entree, breakfast, vegetarian, etc.'),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Try using an emoji!'),
            controller: textEditingController,
          ),
        ],
      )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            upsertTag(tag, textEditingController.value.text);
            Navigator.pop(context);
          },
          child: Text('Add'),
        )
      ],
    );
  }
}
