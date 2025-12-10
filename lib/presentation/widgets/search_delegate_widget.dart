import 'package:biblia/core/utils/reference_parser.dart';
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

        // Check if query is a reference range
        final refs = ReferenceParser.parse(query);
        final rangeRef = refs.where((r) => r.startVerse != null && r.endVerse != null).firstOrNull;

        return ListView.builder(
          itemCount: viewModel.verses.length + (rangeRef != null ? 1 : 0),
          itemBuilder: (context, index) {
            if (rangeRef != null && index == 0) {
              return _buildRangeCard(context, rangeRef, viewModel.verses.first.bookId);
            }

            final verseIndex = rangeRef != null ? index - 1 : index;
            final verse = viewModel.verses[verseIndex];
            
            return ListTile(
              title: Text(verse.text),
              subtitle: Text(
                  '${verse.bookName ?? verse.bookId} ${verse.chapter}:${verse.verse}'),
              onTap: () {
                Modular.to.pushNamed(
                  '/book/${verse.bookId}/${verse.chapter}?verseId=${verse.verse}',
                );
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildRangeCard(BuildContext context, ParsedReference ref, int bookId) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
           final List<int> highlights = [];
           if (ref.startVerse != null && ref.endVerse != null) {
             for (int i = ref.startVerse!; i <= ref.endVerse!; i++) {
               highlights.add(i);
             }
           }
           
           final highlightParam = highlights.join(',');
           
           Modular.to.pushNamed(
             '/book/$bookId/${ref.chapter}?highlight=$highlightParam',
           );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Abrir Intervalo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${ref.bookName} ${ref.chapter}:${ref.startVerse}-${ref.endVerse}',
                 style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Toque para visualizar com destaque'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}