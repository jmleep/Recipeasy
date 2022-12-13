import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/recipe_tag.dart';

class TagList extends StatelessWidget {
  TagList({
    Key? key,
    required this.tags,
    this.showCloseIcon = false,
    this.removeTag,
  }) : super(key: key);

  final List<RecipeTag> tags;
  final bool showCloseIcon;
  final Function(RecipeTag)? removeTag;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return SizedBox.shrink();
    }

    return Wrap(
      children: tags
          .map((e) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: showCloseIcon
                    ? RemoveChip(
                        tag: e,
                        removeTag: removeTag!,
                      )
                    : ViewChip(tag: e),
              ))
          .toList(),
    );
  }
}

class RemoveChip extends StatelessWidget {
  final RecipeTag tag;
  final Function(RecipeTag) removeTag;

  const RemoveChip({Key? key, required this.tag, required this.removeTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
        onDeleted: () => removeTag(tag),
        deleteIconColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: Text(
          tag.value!,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ));
  }
}

class ViewChip extends StatelessWidget {
  final RecipeTag tag;

  const ViewChip({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: Text(
          tag.value!,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ));
  }
}
