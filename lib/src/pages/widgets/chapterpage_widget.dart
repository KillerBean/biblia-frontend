import 'package:flutter/material.dart';
import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/pages/widgets/text_list_items_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChapterPageWidget extends StatefulWidget {
  const ChapterPageWidget(
      {super.key, required this.chapterId, required this.bookId});
  final int chapterId;
  final int bookId;

  @override
  State<ChapterPageWidget> createState() => _ChapterPageWidgetState();
}

class _ChapterPageWidgetState extends State<ChapterPageWidget> {
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
      ),
    );
  }
}
