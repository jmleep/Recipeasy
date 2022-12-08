import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/view_model_home.dart';
import 'list_home_view_arrangement.dart';

class LayoutAndSearch extends StatelessWidget {
  const LayoutAndSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              builder: (context) {
                return HomeViewArrangementList(
                  items: [
                    ArrangementListItem('2 Column Grid', Icons.grid_view, () {
                      context.read<HomeViewModel>().setGridColumnCount(2);
                    }),
                    ArrangementListItem('3 Column Grid', Icons.grid_on, () {
                      context.read<HomeViewModel>().setGridColumnCount(3);
                    }),
                    ArrangementListItem('List', Icons.format_list_bulleted, () {
                      context.read<HomeViewModel>().setIsGrid(false);
                    })
                  ],
                );
              },
              context: context,
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Icon(
              Icons.sort,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 15, top: 15, bottom: 5),
            child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search recipes',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.only(left: 5)),
                onChanged: (value) =>
                    context.read<HomeViewModel>().searchRecipes(value)),
          ),
        )
      ],
    );
  }
}
