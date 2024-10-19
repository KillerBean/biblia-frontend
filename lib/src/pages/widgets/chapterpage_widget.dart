import 'package:flutter/material.dart';

class ChapterPageWidget extends StatefulWidget {
  const ChapterPageWidget(
      {super.key, required this.chapterId, required this.bookId});
  final int chapterId;
  final int bookId;

  @override
  State<ChapterPageWidget> createState() => _ChapterPageWidgetState();
}

class _ChapterPageWidgetState extends State<ChapterPageWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
