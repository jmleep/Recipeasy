import 'package:flutter/material.dart';
import 'package:my_recipes/screens/home/view_model/view_model_home.dart';
import 'package:provider/provider.dart';

class FilterTagSelectorDialog extends StatelessWidget {
  const FilterTagSelectorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeViewModel>().getRecipeTags();
    var tags = context.watch<HomeViewModel>().allRecipeTags;
    var filteredTagIndexes = context.watch<HomeViewModel>().activeFilteredTags;

    if (tags.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(child: CircularProgressIndicator()),
        ],
      );
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      // todo: do i need a container here?
      content: Container(
        width: double.maxFinite,
        child: Wrap(
          spacing: 5.0,
          children: tags.asMap().entries.map((e) {
            int index = e.key;

            // todo: add search actions using filtered tags
            // todo: figure out background color for selected tags
            return GestureDetector(
              onTap: () => filteredTagIndexes.add(index),
              child: Chip(
                  backgroundColor: filteredTagIndexes.contains(index)
                      ? Colors.blue
                      : Theme.of(context).colorScheme.primary,
                  label: Text(
                    e.value.value as String ?? '',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  )),
            );
          }).toList(),
        ),
      ),
    );
  }
}
