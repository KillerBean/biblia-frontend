import 'dart:io';

import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/repositories/fallback_database_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({super.key});

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  late final controller = DatabaseController(FallbackDatabaseRepository());
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

            return Center(
              child: GridView.builder(
                itemCount: controller.books.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (Platform.isWindows || Platform.isLinux || kIsWeb)
                          ? 4
                          : 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  mainAxisExtent: tileHeight,
                ),
                itemBuilder: (_, index) => Center(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        controller.books[index].name,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
