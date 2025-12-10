import 'package:biblia/data/datasources/remote/biblia_remote_data_source.dart';
import 'package:biblia/domain/entities/book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'biblia_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late BibliaRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = BibliaRemoteDataSource(dio: mockDio);
  });

  group('BibliaRemoteDataSource', () {
    const tBaseUrl = 'http://localhost';

    group('getChapters', () {
      test('should call the correct endpoint /books/{bookId}/chapters',
          () async {
        // Arrange
        final tBookId = 1;
        final tResponsePayload = [1, 2, 3, 4, 5]; // 5 chapters

        when(mockDio.get('$tBaseUrl/books/$tBookId/chapters')).thenAnswer(
          (_) async => Response(
            data: tResponsePayload,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await dataSource.getChapters(tBookId);

        // Assert
        verify(mockDio.get('$tBaseUrl/books/$tBookId/chapters'));
        expect(result, 5);
      });

      test('should throw Exception when response code is not 200', () async {
        // Arrange
        final tBookId = 1;
        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: 'Error',
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(() => dataSource.getChapters(tBookId), throwsException);
      });
    });

    group('findBook', () {
      test('should call /books with name query parameter', () async {
        // Arrange
        final tName = 'Genesis';
        final tBookMap = {
          'id': 1,
          'book_reference_id': 1,
          'testament_reference_id': 1,
          'name': 'Genesis'
        };

        when(mockDio.get(
          '$tBaseUrl/books',
          queryParameters: {'name': tName},
        )).thenAnswer(
          (_) async => Response(
            data: [tBookMap],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await dataSource.findBook(tName);

        // Assert
        verify(
            mockDio.get('$tBaseUrl/books', queryParameters: {'name': tName}));
        expect(result, isA<Book>());
        expect(result?.name, 'Genesis');
      });

      test('should return null if list is empty', () async {
        // Arrange
        final tName = 'NonExistent';
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await dataSource.findBook(tName);

        // Assert
        expect(result, null);
      });
    });

    group('getVersesByRange', () {
      test('should call /verses/{bookId}/{chapter} with start and end params',
          () async {
        // Arrange
        final tBookId = 1;
        final tChapter = 1;
        final tStart = 1;
        final tEnd = 5;

        final tVerseMap = {
          'id': 1,
          'book_id': 1,
          'chapter': 1,
          'verse': 1,
          'text': 'In the beginning',
          'book_name': 'Genesis'
        };

        when(mockDio.get(
          '$tBaseUrl/verses/$tBookId/$tChapter',
          queryParameters: {'start': tStart, 'end': tEnd},
        )).thenAnswer(
          (_) async => Response(
            data: [tVerseMap],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await dataSource.getVersesByRange(
          bookId: tBookId,
          chapter: tChapter,
          startVerse: tStart,
          endVerse: tEnd,
        );

        // Assert
        verify(mockDio.get(
          '$tBaseUrl/verses/$tBookId/$tChapter',
          queryParameters: {'start': tStart, 'end': tEnd},
        ));
        expect(result.length, 1);
        expect(result.first.text, 'In the beginning');
      });
    });

    group('searchVerses', () {
      test('should call /search with query and parse nested book object',
          () async {
        // Arrange
        final tQuery = 'beginning';
        final tVerseMap = {
          'id': 1,
          // 'book_id' missing, should use book.id
          'chapter': 1,
          'verse': 1,
          'text': 'In the beginning',
          'book': {'id': 1, 'name': 'Genesis'}
        };

        when(mockDio.get(
          '$tBaseUrl/search',
          queryParameters: {'query': tQuery},
        )).thenAnswer(
          (_) async => Response(
            data: [tVerseMap],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await dataSource.searchVerses(tQuery);

        // Assert
        verify(mockDio
            .get('$tBaseUrl/search', queryParameters: {'query': tQuery}));
        expect(result.length, 1);
        expect(result.first.bookName, 'Genesis');
        expect(result.first.bookId, 1);
      });
    });
  });
}
