import 'dart:io';

import 'package:biblia/src/controllers/database_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BookPageWidget extends StatefulWidget {
  BookPageWidget({super.key, required this.bookId});
  final double tileHeight =
      (Platform.isWindows || Platform.isLinux || kIsWeb) ? 200 : 150;
  final int bookId;

  @override
  State<BookPageWidget> createState() => _BookPageWidgetState();
}

class _BookPageWidgetState extends State<BookPageWidget> {
  late final controller = Modular.get<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
            onPressed: () => Modular.to.navigate("/"),
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

              return Center(
                child: GridView.builder(
                  itemCount: controller.numChapters,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (Platform.isWindows || Platform.isLinux || kIsWeb)
                            ? 4
                            : 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    mainAxisExtent: widget.tileHeight,
                  ),
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      Modular.to
                          .navigate("/book/${widget.bookId}/${index + 1}");
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
                            "${index + 1}",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
