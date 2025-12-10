import 'package:biblia/presentation/viewmodels/verse_viewmodel.dart';
import 'package:biblia/presentation/widgets/text_list_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListVersesPage extends StatefulWidget {
  const ListVersesPage(
      {super.key,
      required this.chapterId,
      required this.bookId,
      this.highlightedVerses});
  final int chapterId;
  final int bookId;
  final List<int>? highlightedVerses;

  @override
  State<ListVersesPage> createState() => _ListVersesPageState();
}

class _ListVersesPageState extends State<ListVersesPage> {
  final VerseViewModel viewModel = Modular.get<VerseViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getVerses(bookId: widget.bookId, chapterId: widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (_, __) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SizedBox.expand(
          child: TextListItemsWidget(
            items: viewModel.verses,
            highlightedVerses: widget.highlightedVerses,
          ),
        );
      },
    );
  }
}
