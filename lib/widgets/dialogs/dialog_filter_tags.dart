import 'package:flutter/material.dart';
import 'package:my_recipes/screens/home/view_model/view_model_home.dart';
import 'package:provider/provider.dart';

class FilterTagSelectorDialog extends StatelessWidget {
  const FilterTagSelectorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeViewModel>().getRecipeTags();
    var tags = context.watch<HomeViewModel>().allRecipeTags;
    var filteredTags = context.watch<HomeViewModel>().activeFilteredTags;

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
          children: tags.map((e) {
            var isFiltered = filteredTags.any(
              (element) => element.value == e.value,
            );

            return GestureDetector(
              onTap: () => context.read<HomeViewModel>().toggleTagFilter(e),
              child: Chip(
                  backgroundColor: isFiltered
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
                  label: Text(
                    // todo: fix this weird string issue
                    e.value as String ?? '',
                    style: TextStyle(
                        color: isFiltered
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.onTertiary),
                  )),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.read<HomeViewModel>().applyTagFilter();
              Navigator.pop(context);
            },
            child: Text('Filter')),
      ],
    );
  }
}
