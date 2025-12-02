import 'package:biblia/presentation/viewmodels/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BibleSearchDelegate extends SearchDelegate {
  final SearchViewModel viewModel = Modular.get<SearchViewModel>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Schedule the search to run after the build phase to avoid "setState during build"
    if (query.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        viewModel.search(query);
      });
    }

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error.isNotEmpty) {
          return Center(child: Text(viewModel.error));
        }

        if (viewModel.verses.isEmpty) {
          return const Center(child: Text('Nenhum versículo encontrado.'));
        }

        return ListView.builder(
          itemCount: viewModel.verses.length,
          itemBuilder: (context, index) {
            final verse = viewModel.verses[index];
            return ListTile(
              title: Text(verse.text),
              subtitle: Text(
                  '${verse.bookName ?? verse.bookId} ${verse.chapter}:${verse.verse}'),
              onTap: () {
                Modular.to.pushNamed(
                  '/book/${verse.bookId}/${verse.chapter}',
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
