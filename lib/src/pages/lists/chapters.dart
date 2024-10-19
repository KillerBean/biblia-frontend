import 'dart:io';

import 'package:biblia/src/controllers/database_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListChaptersPage extends StatefulWidget {
  const ListChaptersPage({super.key});

  @override
  State<ListChaptersPage> createState() => _ListChaptersPageState();
}

class _ListChaptersPageState extends State<ListChaptersPage> {
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

            return Placeholder();
          },
        );
      },
    );
  }
}
