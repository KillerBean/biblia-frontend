import 'package:biblia/presentation/views/lists/verse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChapterPageWidget extends StatelessWidget {
  const ChapterPageWidget(
      {super.key,
      required this.chapterId,
      required this.bookId,
      this.highlightedVerses});
  final int chapterId;
  final int bookId;
  final List<int>? highlightedVerses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
              onPressed: () => Modular.to.pop(),
              icon: const Icon(CupertinoIcons.return_icon)),
        ),
        body: ListVersesPage(
            chapterId: chapterId,
            bookId: bookId,
            highlightedVerses: highlightedVerses));
  }
}
