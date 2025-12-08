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
      final response = await _dio.get('$baseUrl/books', queryParameters: {
        if (testamentId != null) 'testament': testamentId,
      });
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Book.fromMap(e))
            .toList();
      }
    } catch (e) {
      // Log error or rethrow specific exception
      print('API Error getBooks: $e');
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
      print('API Error getTestaments: $e');
    }
     throw Exception('Failed to load testaments from API');
  }

  Future<int> getChapters(int bookId) async {
    try {
      // Assuming endpoint returns list of chapters or details
      // Adjust path according to actual API docs
      final response = await _dio.get('$baseUrl/books/$bookId/chapters');
      
      if (response.statusCode == 200) {
        // If API returns list of chapters objects
        if (response.data is List) {
          return (response.data as List).length;
        } 
        // If API returns a simple count
        if (response.data is Map && response.data['count'] != null) {
          return response.data['count'];
        }
      }
    } catch (e) {
      print('API Error getChapters: $e');
    }
    throw Exception('Failed to load chapters count from API');
  }

  Future<List<Verse>> getVerses({int? bookId, int? chapterId}) async {
    try {
      String path = '$baseUrl/verses';
      Map<String, dynamic> query = {};
      
      if (bookId != null) query['book_id'] = bookId;
      if (chapterId != null) query['chapter'] = chapterId;

      final response = await _dio.get(path, queryParameters: query);
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Verse.fromMap(e))
            .toList();
      }
    } catch (e) {
      print('API Error getVerses: $e');
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
      // Assuming a robust search or filter endpoint exists
      // If not, we might need to fetch all and filter (inefficient)
      // Or use query params like ?start=X&end=Y
      final query = {
        'book_id': bookId,
        'chapter': chapter,
      };
      if (startVerse != null) query['start_verse'] = startVerse;
      if (endVerse != null) query['end_verse'] = endVerse;

      final response = await _dio.get('$baseUrl/verses/range', queryParameters: query);
      
      if (response.statusCode == 200) {
         return (response.data as List)
            .map((e) => Verse.fromMap(e))
            .toList();
      }
    } catch (e) {
       print('API Error getVersesByRange: $e');
    }
    throw Exception('Failed to load verses range from API');
  }

  Future<Book?> findBook(String name) async {
    try {
      final response = await _dio.get('$baseUrl/books/search', queryParameters: {'name': name});
      
      if (response.statusCode == 200 && (response.data as List).isNotEmpty) {
        return Book.fromMap((response.data as List).first);
      }
    } catch (e) {
      print('API Error findBook: $e');
    }
    return null;
  }

  Future<List<Verse>> searchVerses(String query) async {
    try {
      final response = await _dio.get('$baseUrl/search', queryParameters: {'q': query});
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Verse.fromMap(e))
            .toList();
      }
    } catch (e) {
      print('API Error searchVerses: $e');
    }
    return [];
  }
}
