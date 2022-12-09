import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/view_model_add_edit_recipe.dart';

class AddTag extends StatelessWidget {
  const AddTag({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Theme.of(context).colorScheme.primary)),
          child: TextButton(
            onPressed: () {
              context.read<AddEditRecipeViewModel>().addTag(context);
            },
            child: Row(
              children: [Icon(Icons.add), Text('Add tag')],
            ),
          ),
        ),
      ],
    );
  }
}
