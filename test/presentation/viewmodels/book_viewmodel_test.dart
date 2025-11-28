import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/usecases/get_books_usecase.dart';
import 'package:biblia/domain/usecases/get_testaments_usecase.dart';
import 'package:biblia/presentation/viewmodels/book_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'book_viewmodel_test.mocks.dart';

@GenerateMocks([GetBooksUseCase, GetTestamentsUseCase])
void main() {
  late BookViewModel bookViewModel;
  late MockGetBooksUseCase mockGetBooksUseCase;
  late MockGetTestamentsUseCase mockGetTestamentsUseCase;

  setUp(() {
    mockGetBooksUseCase = MockGetBooksUseCase();
    mockGetTestamentsUseCase = MockGetTestamentsUseCase();
    bookViewModel = BookViewModel(mockGetBooksUseCase, mockGetTestamentsUseCase);
  });

  group('BookViewModel', () {
    test('getBooks should call GetBooksUseCase and update books list',
        () async {
      // Arrange
      final books = [Book(id: 1, name: 'Genesis', testamentReferenceId: 1, bookReferenceId: 1)];
      when(mockGetBooksUseCase.call()).thenAnswer((_) async => books);

      // Act
      await bookViewModel.getBooks();

      // Assert
      expect(bookViewModel.books, equals(books));
      verify(mockGetBooksUseCase.call());
    });

    test('getTestaments should call GetTestamentsUseCase and update testaments list',
        () async {
      // Arrange
      when(mockGetTestamentsUseCase.call()).thenAnswer((_) async => []);

      // Act
      await bookViewModel.getTestaments();

      // Assert
      verify(mockGetTestamentsUseCase.call());
    });

    test('isLoading should be true while fetching data', () {
      // Arrange
      when(mockGetBooksUseCase.call()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      // Act
      final future = bookViewModel.getBooks();

      // Assert
      expect(bookViewModel.isLoading, isTrue);

      // Act
      future.whenComplete(() {
        // Assert
        expect(bookViewModel.isLoading, isFalse);
      });
    });

    test('getBooks should set errorMessage when an exception occurs', () async {
      // Arrange
      final exception = Exception('Database error');
      when(mockGetBooksUseCase.call()).thenThrow(exception);

      // Act
      await bookViewModel.getBooks();

      // Assert
      expect(bookViewModel.books, isEmpty);
      expect(bookViewModel.errorMessage, contains('Falha ao carregar livros'));
      expect(bookViewModel.isLoading, isFalse);
    });

    test('getTestaments should set errorMessage when an exception occurs', () async {
      // Arrange
      final exception = Exception('Network error');
      when(mockGetTestamentsUseCase.call()).thenThrow(exception);

      // Act
      await bookViewModel.getTestaments();

      // Assert
      expect(bookViewModel.testaments, isEmpty);
      expect(bookViewModel.errorMessage, contains('Falha ao carregar testamentos'));
      expect(bookViewModel.isLoading, isFalse);
    });
  });
}