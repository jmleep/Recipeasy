import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArrangementListItem {
  final String text;
  final IconData icon;
  final Function() onTap;

  ArrangementListItem(this.text, this.icon, this.onTap);
}

class HomeViewArrangementList extends StatefulWidget {
  final List<ArrangementListItem> items;

  const HomeViewArrangementList({Key? key, required this.items})
      : super(key: key);

  @override
  State<HomeViewArrangementList> createState() =>
      _HomeViewArrangementListState();
}

class _HomeViewArrangementListState extends State<HomeViewArrangementList> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.33,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView.separated(
          padding: EdgeInsets.all(20),
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              widget.items[index].onTap();
              Navigator.pop(context);
            },
            tileColor: Theme.of(context).colorScheme.background,
            leading: Icon(widget.items[index].icon,
                color: Theme.of(context).colorScheme.onSurface),
            title: Text(
              widget.items[index].text,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
