import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListItemsWidget extends StatefulWidget {
  ListItemsWidget(
      {super.key, required this.items, this.path, required this.fieldName});
  List<dynamic> items;
  String? path;
  String fieldName;
  final double tileHeight =
      (Platform.isWindows || Platform.isLinux || kIsWeb) ? 200 : 150;

  @override
  State<ListItemsWidget> createState() => _ListItemsWidgetState();
}

class _ListItemsWidgetState extends State<ListItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        itemCount: widget.items.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              (Platform.isWindows || Platform.isLinux || kIsWeb) ? 4 : 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          mainAxisExtent: widget.tileHeight,
        ),
        itemBuilder: (_, index) => GestureDetector(
          onTap: () {
            print("/${widget.path}/${index + 1}");
            if (widget.path != null) {
              Modular.to.navigate("/${widget.path}/${index + 1}");
            }
          },
          child: Center(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 167, 167, 167),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Center(
                child: Text(
                  (widget.items[index]).toMap()[widget.fieldName],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
