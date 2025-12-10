import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:dio/dio.dart';

class BibliaRemoteDataSource {
  final Dio _dio;
  final String baseUrl;
  Map<int, String>? _bookNamesCache;

  BibliaRemoteDataSource({Dio? dio, this.baseUrl = 'http://localhost'})
      : _dio = dio ?? Dio();

  Future<void> _ensureBookNamesLoaded() async {
    if (_bookNamesCache != null) return;

    try {
      final books = await getBooks();
      _bookNamesCache = {for (var b in books) b.id: b.name};
    } catch (e) {
      print('Warning: Failed to load book names for cache: $e');
    }
  }

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
      // The API does not have a direct endpoint for chapter count.
      // We must fetch all verses for the book and count unique chapters.
      // This is inefficient but necessary with the current API design.
      // TODO: Consider adding a dedicated endpoint in the API for chapter counts.
      final response = await _dio.get('$baseUrl/verses/$bookId');

      if (response.statusCode == 200) {
        final List<dynamic> versesData = response.data;
        if (versesData.isEmpty) return 0;

        final uniqueChapters =
            versesData.map((v) => v['chapter'] as int).toSet();

        return uniqueChapters.length;
      }
    } catch (e) {
      print('API Error getChapters: $e');
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
        // If no bookId is provided, the API might not support getting ALL verses of the bible at once
        // via a root /verses endpoint based on the swagger doc provided.
        // However, the interface requires this method.
        // We will try the base /verses endpoint if it exists or return empty.
        // Based on swagger, /verses/{bookId} is the rootest valid path.
        // Returning empty list if bookId is null to avoid error.
        return [];
      }

      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Verse.fromMap(e)).toList();
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

        // API does not support range queries. Fetch the full chapter and filter locally.

        final response = await _dio.get('$baseUrl/verses/$bookId/$chapter');

        

        if (response.statusCode == 200) {

           var verses = (response.data as List)

              .map((e) => Verse.fromMap(e))

              .toList();

  

           if (startVerse != null) {

             verses = verses.where((v) => v.verse >= startVerse).toList();

           }

           

           if (endVerse != null) {

             verses = verses.where((v) => v.verse <= endVerse).toList();

           } else if (startVerse != null) {

             // Behavior consistency: if only startVerse is given, return only that verse? 

             // Or from that verse to the end?

             // The repository implementation suggests:

             // if (startVerse != null && endVerse == null) -> sql += " AND v.verse = ?"

             // So strictly single verse if endVerse is null.

             verses = verses.where((v) => v.verse == startVerse).toList();

           }

           

           return verses;

        }

      } catch (e) {

         print('API Error getVersesByRange: $e');

      }

      throw Exception('Failed to load verses range from API');

    }

  

  Future<Book?> findBook(String name) async {
    try {
      // No dedicated search endpoint for books found in swagger.
      // Fetching all books and filtering locally.
      final response = await _dio.get('$baseUrl/books');
      
      if (response.statusCode == 200) {
        final books = (response.data as List)
            .map((e) => Book.fromMap(e))
            .toList();
            
        try {
          // Simple case-insensitive prefix match
          return books.firstWhere(
            (b) => b.name.toLowerCase().startsWith(name.toLowerCase()),
          );
        } catch (e) {
          return null;
        }
      }
    } catch (e) {
      print('API Error findBook: $e');
    }
    return null;
  }

  Future<List<Verse>> searchVerses(String query) async {
    try {
      final response =
          await _dio.get('$baseUrl/search', queryParameters: {'query': query});

      if (response.statusCode == 200) {
        await _ensureBookNamesLoaded();
        
        return (response.data as List).map((e) {
          final verse = Verse.fromMap(e);
          if (_bookNamesCache != null && _bookNamesCache!.containsKey(verse.bookId)) {
            verse.bookName = _bookNamesCache![verse.bookId];
          }
          return verse;
        }).toList();
      }
    } catch (e) {
      if (e is DioException) {
         print('API Error searchVerses: ${e.message} - ${e.response?.data}');
      } else {
         print('API Error searchVerses: $e');
      }
    }
    return [];
  }
}
