import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GridListItemsWidget extends StatefulWidget {
  GridListItemsWidget(
      {super.key, required this.items, this.path, required this.fieldName});
  final List<dynamic> items;
  final String? path;
  final String fieldName;
  final double tileHeight =
      (Platform.isWindows || Platform.isLinux || kIsWeb) ? 200 : 150;

  @override
  State<GridListItemsWidget> createState() => _GridListItemsWidgetState();
}

class _GridListItemsWidgetState extends State<GridListItemsWidget> {
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
            if (widget.path != null) {
              final itemId = (widget.items[index]).toMap()['id'];
              Modular.to.pushNamed("/${widget.path}/$itemId");
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
                  style: TextStyle(
                    fontSize: (Platform.isWindows || Platform.isLinux || kIsWeb)
                        ? 24
                        : 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.none,
                  ),
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
