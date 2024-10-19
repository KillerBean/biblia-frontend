import 'package:flutter/material.dart';

class TextListItemsWidget extends StatelessWidget {
  const TextListItemsWidget({super.key, required this.items});
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            return Text("${index + 1} - ${items[index].text}");
          }),
    );
  }
}
