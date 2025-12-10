import 'package:biblia/core/utils/config_service.dart';
import 'package:biblia/core/utils/reference_parser.dart';
import 'package:biblia/data/datasources/remote/biblia_remote_data_source.dart';
import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/data/datasources/local/local_sqlite.dart';
import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FallbackDatabaseRepository extends DatabaseRepository {
  final Future<Database> Function() _dbProvider;
  final BibliaRemoteDataSource _remoteDataSource;
  final ConfigService _configService;

  FallbackDatabaseRepository(
    this._remoteDataSource,
    this._configService, {
    Future<Database> Function()? dbProvider,
  }) : _dbProvider = dbProvider ?? (() => DatabaseRetriever.instance.db);

  Future<bool> _shouldUseApi() async {
    return await _configService.isApiEnabled();
  }

  @override
  Future<List<Book>> getBooks({int? testament}) async {
    if (await _shouldUseApi()) {
      try {
        return await _remoteDataSource.getBooks(testamentId: testament);
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    List<Book> books = [];
    final db = await _dbProvider();
    final rawBooks = await db.query("book",
        columns: ["id", "book_reference_id", "testament_reference_id", "name"]);
    for (final item in rawBooks) {
      books.add(Book.fromMap(item));
    }
    return books;
  }

  @override
  Future<List<Testament>> getTestaments() async {
    if (await _shouldUseApi()) {
      try {
        return await _remoteDataSource.getTestaments();
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    List<Testament> testaments = [];
    final db = await _dbProvider();
    final rawTestaments = await db.query("testament", columns: ["id", "name"]);
    for (final item in rawTestaments) {
      testaments.add(Testament.fromMap(item));
    }
    return testaments;
  }

  @override
  Future<int> getChapters({required int bookId}) async {
    if (await _shouldUseApi()) {
      try {
        return await _remoteDataSource.getChapters(bookId);
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    final db = await _dbProvider();
    final rawVerses = await db.rawQuery(
        "SELECT * FROM verse WHERE book_id = ? GROUP BY chapter", [bookId]);

    return rawVerses.length;
  }

  @override
  Future<Book?> findBook(String name) async {
    if (await _shouldUseApi()) {
      try {
        final book = await _remoteDataSource.findBook(name);
        if (book != null) return book;
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    final db = await _dbProvider();
    final res = await db.query(
      "book",
      where: "name LIKE ?",
      whereArgs: ['$name%'],
      limit: 1,
    );

    if (res.isNotEmpty) {
      return Book.fromMap(res.first);
    }
    return null;
  }

  @override
  Future<List<Verse>> getVersesByRange({
    required int bookId,
    required int chapter,
    int? startVerse,
    int? endVerse,
  }) async {
    if (await _shouldUseApi()) {
      try {
        return await _remoteDataSource.getVersesByRange(
          bookId: bookId,
          chapter: chapter,
          startVerse: startVerse,
          endVerse: endVerse,
        );
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    List<Verse> verses = [];
    final db = await _dbProvider();

    String sql =
        "SELECT v.*, b.name as book_name FROM verse v JOIN book b ON v.book_id = b.id WHERE v.book_id = ? AND v.chapter = ?";
    List<dynamic> args = [bookId, chapter];

    if (startVerse != null && endVerse != null) {
      sql += " AND v.verse >= ? AND v.verse <= ?";
      args.add(startVerse);
      args.add(endVerse);
    } else if (startVerse != null) {
      sql += " AND v.verse = ?";
      args.add(startVerse);
    }

    final rawVerses = await db.rawQuery(sql, args);

    for (final item in rawVerses) {
      verses.add(Verse.fromMap(item));
    }
    return verses;
  }

  @override
  Future<List<Verse>> getVerses({int? chapterId, int? bookId}) async {
    if (await _shouldUseApi()) {
      try {
        return await _remoteDataSource.getVerses(
            bookId: bookId, chapterId: chapterId);
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    List<Verse> verses = [];
    List<dynamic> rawVerses = [];
    final db = await _dbProvider();

    if (bookId == null) {
      if (chapterId == null) {
        rawVerses = await db.query("verse",
            columns: ["id", "book_id", "chapter", "verse", "text"]);
      }
    } else {
      if (chapterId == null) {
        rawVerses = await db
            .rawQuery("SELECT * FROM verse WHERE book_id = ?", [bookId]);
      }
      if (chapterId != null) {
        rawVerses = await db.rawQuery(
            "SELECT * FROM verse WHERE book_id = ? AND chapter = ?",
            [bookId, chapterId]);
      }
    }

    for (final item in rawVerses) {
      verses.add(Verse.fromMap(item));
    }
    return verses;
  }

  @override
  Future<List<Verse>> searchVerses(String query) async {
    if (await _shouldUseApi()) {
      try {
        return await _remoteDataSource.searchVerses(query);
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    // Local Logic: Try parsing references first
    final references = ReferenceParser.parse(query);

    if (references.isNotEmpty) {
      final List<Verse> results = [];
      bool foundAnyReference = false;

      for (final ref in references) {
        final book = await findBook(ref.bookName);

        if (book != null) {
          foundAnyReference = true;

          final verses = await getVersesByRange(
            bookId: book.id,
            chapter: ref.chapter,
            startVerse: ref.startVerse,
            endVerse: ref.endVerse,
          );

          results.addAll(verses);
        }
      }

      if (foundAnyReference) {
        return results;
      }
    }

    // Fallback to text search
    List<Verse> verses = [];
    final db = await _dbProvider();

    final rawVerses = await db.rawQuery(
      "SELECT v.*, b.name as book_name FROM verse v JOIN book b ON v.book_id = b.id WHERE v.text LIKE ? LIMIT 100",
      ['%$query%'],
    );

    for (final item in rawVerses) {
      verses.add(Verse.fromMap(item));
    }

    return verses;
  }
}

