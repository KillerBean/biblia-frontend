import 'dart:io';

import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/pages/widgets/list_items_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BookPageWidget extends StatefulWidget {
  BookPageWidget({super.key, required this.bookId});
  int bookId;

  @override
  State<BookPageWidget> createState() => _BookPageWidgetState();
}

class _BookPageWidgetState extends State<BookPageWidget> {
  late final controller = Modular.get<DatabaseController>();
  final double tileHeight =
      (Platform.isWindows || Platform.isLinux || kIsWeb) ? 200 : 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
            onPressed: () => Modular.to.pop(),
            icon: const Icon(CupertinoIcons.return_icon)),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (_, __) {
          return FutureBuilder(
            future: controller.getChapters(bookId: widget.bookId),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                const CircularProgressIndicator();
              }

              return ListItemsWidget(
                items: controller.verses,
                fieldName: "chapter",
              );
            },
          );
        },
      ),
    );
  }
}
