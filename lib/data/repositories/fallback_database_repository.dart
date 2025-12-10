import 'package:biblia/core/utils/config_service.dart';
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
        // If API returns null, we might want to try local too?
        // Or assume API is authoritative?
        // Let's fallback to local if null or error.
      } catch (e) {
        print('Fallback to local: API failed: $e');
      }
    }

    final db = await _dbProvider();
    // Tenta encontrar correspondência exata ou parcial no início
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

    // Re-implementando lógica de range correta
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
        //busca todos os versículos
        rawVerses = await db.query("verse",
            columns: ["id", "book_id", "chapter", "verse", "text"]);
      }
    } else {
      if (chapterId == null) {
        //busca todos os versículos de um livro específico
        rawVerses = await db
            .rawQuery("SELECT * FROM verse WHERE book_id = ?", [bookId]);
      }
      if (chapterId != null) {
        //busca todos os versículos de um livro e capítulo específicos
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

    final references = _parseReferences(query);

    if (references.isNotEmpty) {
      final List<Verse> results = [];

      bool foundAnyReference = false;

      for (final ref in references) {
        // Reuse findBook and getVersesByRange (which handle local fallback logic internally if needed,

        // but here we are already in the "Fallback or Local" context, so we can rely on public methods

        // which will route back to local implementation because we are in FallbackDatabaseRepository)

        // Actually, to avoid recursion or double checks, we should call local implementations directly?

        // But findBook/getVersesByRange also check _shouldUseApi().

        // Since we are in the "Local" block of searchVerses (because API failed or is disabled),

        // we should ideally call the LOCAL logic directly.

        // However, refactoring everything to separate private _localFindBook is complex.

        // Calling this.findBook() is safe because it checks _shouldUseApi() again.

        // If _shouldUseApi() is false, it uses local.

        // If it was true but failed (catch block above), calling this.findBook() might try API again?

        // YES. That is a minor inefficiency but correct behavior (retry).

        // BUT, if we are in the catch block, we might want to FORCE local.

        // Let's assume for now calling public methods is fine.

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

  List<_ParsedReference> _parseReferences(String query) {
    final List<_ParsedReference> refs = [];

    final parts = query.split(';');

    final regex = RegExp(
      r'^((?:\d\s*)?[a-zA-ZÀ-ÿ]+(?:\s+[a-zA-ZÀ-ÿ]+)*)\s+(\d+)(?::(\d+)(?:-(\d+))?)?$',
    );

    for (var part in parts) {
      part = part.trim();

      final match = regex.firstMatch(part);

      if (match != null) {
        final bookName = match.group(1)!.trim();

        final chapter = int.parse(match.group(2)!);

        final startVerse =
            match.group(3) != null ? int.parse(match.group(3)!) : null;

        final endVerse =
            match.group(4) != null ? int.parse(match.group(4)!) : null;

        refs.add(_ParsedReference(bookName, chapter, startVerse, endVerse));
      }
    }

    return refs;
  }
}

class _ParsedReference {
  final String bookName;

  final int chapter;

  final int? startVerse;

  final int? endVerse;

  _ParsedReference(this.bookName, this.chapter, this.startVerse, this.endVerse);
}
