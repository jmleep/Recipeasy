import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewExpansionPanel extends StatelessWidget {
  final String title;
  final bool isInitiallyExpanded;
  final List<dynamic> items;
  final String noItemsText;
  final Function(BuildContext, int) itemBuilder;

  const ViewExpansionPanel(
      {Key? key,
      required this.title,
      required this.isInitiallyExpanded,
      required this.items,
      required this.noItemsText,
      required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 25)),
      initiallyExpanded: isInitiallyExpanded,
      children: [
        items.length == 0
            ? Container(padding: EdgeInsets.all(10), child: Text(noItemsText))
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) =>
                    itemBuilder(context, index))
      ],
    );
  }
}
