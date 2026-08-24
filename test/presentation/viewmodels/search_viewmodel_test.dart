import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/usecases/search_verses_usecase.dart';
import 'package:biblia/presentation/viewmodels/search_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDatabaseRepository implements DatabaseRepository {
  int searchCalls = 0;
  String? lastQuery;

  @override
  Future<List<Verse>> searchVerses(String query) async {
    searchCalls++;
    lastQuery = query;
    return [];
  }

  @override
  Future<List<Book>> getBooks({int? testament}) => throw UnimplementedError();

  @override
  Future<int> getChapters({required int bookId}) => throw UnimplementedError();

  @override
  Future<List<Verse>> getVerses({int? bookId, int? chapterId}) =>
      throw UnimplementedError();

  @override
  Future<List<Verse>> getVersesByRange({
    required int bookId,
    required int chapter,
    int? startVerse,
    int? endVerse,
  }) =>
      throw UnimplementedError();

  @override
  Future<Book?> findBook(String name) => throw UnimplementedError();

  @override
  Future<List<Testament>> getTestaments() => throw UnimplementedError();
}

void main() {
  test('rejects queries above the maximum length', () async {
    final repository = FakeDatabaseRepository();
    final viewModel = SearchViewModel(SearchVersesUseCase(repository));

    await viewModel.search('a' * (SearchViewModel.maxQueryLength + 1));

    expect(viewModel.error, contains('Máximo de 200'));
    expect(repository.searchCalls, 0);
    viewModel.dispose();
  });

  test('debounces search requests', () async {
    final repository = FakeDatabaseRepository();
    final viewModel = SearchViewModel(SearchVersesUseCase(repository));

    await viewModel.search('amor');
    expect(repository.searchCalls, 0);

    await Future<void>.delayed(
        SearchViewModel.searchDebounce + const Duration(milliseconds: 100));

    expect(repository.searchCalls, 1);
    expect(repository.lastQuery, 'amor');
    expect(viewModel.isLoading, false);
    viewModel.dispose();
  });
}
