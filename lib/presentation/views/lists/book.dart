import 'package:biblia/presentation/viewmodels/book_viewmodel.dart';
import 'package:biblia/presentation/widgets/grid_list_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({super.key});

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  final BookViewModel viewModel = Modular.get<BookViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (_, __) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridListItemsWidget(
          items: viewModel.books,
          path: "book",
          fieldName: "name",
        );
      },
    );
  }
}