import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/recipe_tag.dart';

class TagList extends StatelessWidget {
  const TagList({
    Key? key,
    required this.tags,
  }) : super(key: key);

  final List<RecipeTag> tags;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Chip(label: Text(tags[index].value!)),
          );
        },
      ),
    );
  }
}
