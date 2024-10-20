import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/pages/widgets/text_list_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListVersesPage extends StatefulWidget {
  const ListVersesPage(
      {super.key, required this.chapterId, required this.bookId});
  final int chapterId;
  final int bookId;

  @override
  State<ListVersesPage> createState() => _ListVersesPageState();
}

class _ListVersesPageState extends State<ListVersesPage> {
  late final controller = Modular.get<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, __) {
        return FutureBuilder(
          future: controller.getVerses(
              bookId: widget.bookId, chapterId: widget.chapterId),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              const CircularProgressIndicator();
            }

            return SizedBox.expand(
              child: TextListItemsWidget(items: controller.verses),
            );
          },
        );
      },
    );
  }
}
