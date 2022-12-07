import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/view_model_home.dart';

class RecipeList extends StatelessWidget {
  const RecipeList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            bool hasImage =
                context.watch<HomeViewModel>().recipes[index].primaryImage !=
                    null;
            return ListTile(
              leading: hasImage
                  ? AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FittedBox(
                              child: Image.memory(context
                                  .watch<HomeViewModel>()
                                  .recipes[index]
                                  .primaryImage!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  : null,
              title: Padding(
                padding: hasImage ? EdgeInsets.zero : EdgeInsets.only(left: 5),
                child: Text(context.watch<HomeViewModel>().recipes[index].name),
              ),
              onTap: () {
                context.read<HomeViewModel>().navigateTo(
                    context, context.read<HomeViewModel>().recipes[index]);
              },
            );
          },
          separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).colorScheme.onSurface,
              ),
          itemCount: context.watch<HomeViewModel>().recipes.length),
    );
  }
}
