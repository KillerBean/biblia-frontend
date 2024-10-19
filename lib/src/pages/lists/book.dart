import 'dart:io';

import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/pages/widgets/list_items_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({super.key});

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  late final controller = Modular.get<DatabaseController>();
  final double tileHeight =
      (Platform.isWindows || Platform.isLinux || kIsWeb) ? 200 : 150;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, __) {
        return FutureBuilder(
          future: controller.getBooks(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              const CircularProgressIndicator();
            }

            return ListItemsWidget(
              items: controller.books,
              path: "book",
              fieldName: "name",
            );
          },
        );
      },
    );
  }
}
