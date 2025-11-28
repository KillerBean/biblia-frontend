import 'package:biblia/data/repositories/fallback_database_repository.dart';
import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'fallback_database_repository_unit_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late FallbackDatabaseRepository repository;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    repository =
        FallbackDatabaseRepository(dbProvider: () async => mockDatabase);
  });

  group('FallbackDatabaseRepository Unit Tests', () {
    group('getBooks', () {
      test('should return list of books from database', () async {
        // Arrange
        final expectedData = [
          {
            'id': 1,
            'book_reference_id': 1,
            'testament_reference_id': 1,
            'name': 'Gênesis'
          },
          {
            'id': 2,
            'book_reference_id': 2,
            'testament_reference_id': 1,
            'name': 'Êxodo'
          },
        ];

        when(mockDatabase.query('book', columns: anyNamed('columns')))
            .thenAnswer((_) async => expectedData);

        // Act
        final result = await repository.getBooks();

        // Assert
        expect(result, isA<List<Book>>());
        expect(result.length, 2);
        expect(result.first.name, 'Gênesis');
        verify(mockDatabase.query('book', columns: [
          "id",
          "book_reference_id",
          "testament_reference_id",
          "name"
        ])).called(1);
      });

      test('should return empty list when db is empty', () async {
        // Arrange
        when(mockDatabase.query('book', columns: anyNamed('columns')))
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.getBooks();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getTestaments', () {
      test('should return list of testaments', () async {
        // Arrange
        final expectedData = [
          {'id': 1, 'name': 'Antigo Testamento'},
          {'id': 2, 'name': 'Novo Testamento'},
        ];

        when(mockDatabase.query('testament', columns: anyNamed('columns')))
            .thenAnswer((_) async => expectedData);

        // Act
        final result = await repository.getTestaments();

        // Assert
        expect(result, isA<List<Testament>>());
        expect(result.length, 2);
        expect(result.first.name, 'Antigo Testamento');
      });
    });

    group('getChapters', () {
      test('should return count of chapters based on distinct verses query',
          () async {
        // Arrange
        final bookId = 1;
        // O repositório usa rawQuery com GROUP BY e conta o tamanho da lista retornada
        final expectedData = [
          {'chapter': 1},
          {'chapter': 2},
          {'chapter': 3},
        ];

        when(mockDatabase.rawQuery(any, [bookId]))
            .thenAnswer((_) async => expectedData);

        // Act
        final result = await repository.getChapters(bookId: bookId);

        // Assert
        expect(result, 3);
        verify(mockDatabase.rawQuery(
            "SELECT * FROM verse WHERE book_id = ? GROUP BY chapter",
            [bookId])).called(1);
      });
    });

    group('getVerses', () {
      final verseData = {
        'id': 1,
        'book_id': 1,
        'chapter': 1,
        'verse': 1,
        'text': 'No princípio...'
      };

      test('should get all verses when arguments are null', () async {
        // Arrange
        when(mockDatabase.query('verse', columns: anyNamed('columns')))
            .thenAnswer((_) async => [verseData]);

        // Act
        final result = await repository.getVerses();

        // Assert
        expect(result.length, 1);
        verify(mockDatabase.query('verse', columns: anyNamed('columns')))
            .called(1);
      });

      test('should get verses by bookId only', () async {
        // Arrange
        final bookId = 1;
        when(mockDatabase.rawQuery(any, [bookId]))
            .thenAnswer((_) async => [verseData]);

        // Act
        final result = await repository.getVerses(bookId: bookId);

        // Assert
        expect(result.length, 1);
        verify(mockDatabase.rawQuery(
            "SELECT * FROM verse WHERE book_id = ?", [bookId])).called(1);
      });

      test('should get verses by bookId and chapterId', () async {
        // Arrange
        final bookId = 1;
        final chapterId = 1;
        when(mockDatabase.rawQuery(any, [bookId, chapterId]))
            .thenAnswer((_) async => [verseData]);

        // Act
        final result =
            await repository.getVerses(bookId: bookId, chapterId: chapterId);

        // Assert
        expect(result.length, 1);
        verify(mockDatabase.rawQuery(
            "SELECT * FROM verse WHERE book_id = ? AND chapter = ?",
            [bookId, chapterId])).called(1);
      });
    });
  });
}
