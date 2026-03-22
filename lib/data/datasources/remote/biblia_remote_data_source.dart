import 'package:biblia/core/utils/app_logger.dart';
import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:dio/dio.dart';

class BibliaRemoteDataSource {
  final Dio _dio;
  final String baseUrl;

  BibliaRemoteDataSource({Dio? dio, this.baseUrl = 'http://localhost'})
      : _dio = dio ?? Dio();

  Future<List<Book>> getBooks({int? testamentId}) async {
    try {
      String path = '$baseUrl/books';
      if (testamentId != null) {
        path += '/testament/$testamentId';
      }

      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Book.fromMap(e)).toList();
      }
    } catch (e) {
      appLogger.w('API Error getBooks', error: e is DioException ? e.message : null);
    }
    throw Exception('Failed to load books from API');
  }

  Future<List<Testament>> getTestaments() async {
    try {
      final response = await _dio.get('$baseUrl/testaments');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Testament.fromMap(e))
            .toList();
      }
    } catch (e) {
      appLogger.w('API Error getTestaments', error: e is DioException ? e.message : null);
    }
    throw Exception('Failed to load testaments from API');
  }

  Future<int> getChapters(int bookId) async {
    try {
      final response = await _dio.get('$baseUrl/books/$bookId/chapters');

      if (response.statusCode == 200) {
        final List<dynamic> chapters = response.data;
        return chapters.length;
      }
    } catch (e) {
      appLogger.w('API Error getChapters', error: e is DioException ? e.message : null);
    }
    throw Exception('Failed to load chapters count from API');
  }

  Future<List<Verse>> getVerses({int? bookId, int? chapterId}) async {
    try {
      String path = '$baseUrl/verses';

      if (bookId != null) {
        path += '/$bookId';
        if (chapterId != null) {
          path += '/$chapterId';
        }
      } else {
        return [];
      }

      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Verse.fromMap(e)).toList();
      }
    } catch (e) {
      appLogger.w('API Error getVerses', error: e is DioException ? e.message : null);
    }
    throw Exception('Failed to load verses from API');
  }

  Future<List<Verse>> getVersesByRange({
    required int bookId,
    required int chapter,
    int? startVerse,
    int? endVerse,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (startVerse != null) queryParams['start'] = startVerse;
      if (endVerse != null) queryParams['end'] = endVerse;

      final response = await _dio.get(
        '$baseUrl/verses/$bookId/$chapter',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Verse.fromMap(e)).toList();
      }
    } catch (e) {
      appLogger.w('API Error getVersesByRange', error: e is DioException ? e.message : null);
    }
    throw Exception('Failed to load verses range from API');
  }

  Future<Book?> findBook(String name) async {
    try {
      final response = await _dio.get(
        '$baseUrl/books',
        queryParameters: {'name': name},
      );

      if (response.statusCode == 200) {
        final books = (response.data as List)
            .map((e) => Book.fromMap(e))
            .toList();

        if (books.isNotEmpty) {
          return books.first;
        }
      }
    } catch (e) {
      appLogger.w('API Error findBook', error: e is DioException ? e.message : null);
    }
    return null;
  }

  Future<List<Verse>> searchVerses(String query) async {
    try {
      final response = await _dio.get(
        '$baseUrl/search',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Verse.fromMap(e)).toList();
      }
    } catch (e) {
      // Never log response data — may contain sensitive content.
      appLogger.w('API Error searchVerses', error: e is DioException ? e.message : null);
    }
    return [];
  }
}
