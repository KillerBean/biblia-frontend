import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/data/datasources/local/local_sqlite.dart';
import 'package:biblia/domain/repositories/database_repository.dart';

class FallbackDatabaseRepository extends DatabaseRepository {
  @override
  Future<List<Book>> getBooks({int? testament}) async {
    List<Book> books = [];
    final rawBooks = await (await DatabaseRetriever.instance.db).query("book",
        columns: ["id", "book_reference_id", "testament_reference_id", "name"]);
    for (final item in rawBooks) {
      books.add(Book.fromMap(item));
    }
    return books;
  }

  @override
  Future<List<Testament>> getTestaments() async {
    List<Testament> testaments = [];
    final rawTestaments = await (await DatabaseRetriever.instance.db)
        .query("testament", columns: ["id", "name"]);
    for (final item in rawTestaments) {
      testaments.add(Testament.fromMap(item));
    }
    return testaments;
  }

  @override
  Future<int> getChapters({required int bookId}) async {
    final rawVerses = await (await DatabaseRetriever.instance.db).rawQuery(
        "SELECT * FROM verse WHERE book_id = ? GROUP BY chapter", [bookId]);

    return rawVerses.length;
  }

  @override
  Future<List<Verse>> getVerses({int? chapterId, int? bookId}) async {
    List<Verse> verses = [];
    List<dynamic> rawVerses = [];

    if (bookId == null) {
      if (chapterId == null) {
        //busca todos os versículos
        rawVerses = await (await DatabaseRetriever.instance.db).query("verse",
            columns: ["id", "book_id", "chapter", "verse", "text"]);
      }
    } else {
      if (chapterId == null) {
        //busca todos os versículos de um livro específico
        rawVerses = await (await DatabaseRetriever.instance.db)
            .rawQuery("SELECT * FROM verse WHERE book_id = ?", [bookId]);
      }
      if (chapterId != null) {
        //busca todos os versículos de um livro e capítulo específicos
        rawVerses = await (await DatabaseRetriever.instance.db).rawQuery(
            "SELECT * FROM verse WHERE book_id = ? AND chapter = ?",
            [bookId, chapterId]);
      }
    }

    /*
     * modo antigo de maior complexidade ciclomática
    // if (chapterId != null && bookId == null) return [];

    // if (chapterId != null && bookId != null) {
    //   rawVerses = await (await DatabaseRetriever.instance.db).rawQuery(
    //       "SELECT * FROM verse WHERE book_id = ? AND chapter = ?",
    //       [bookId, chapterId]);
    // }

    // if (bookId != null && chapterId == null) {
    //   rawVerses = await (await DatabaseRetriever.instance.db)
    //       .rawQuery("SELECT * FROM verse WHERE book_id = ?", [bookId]);
    // }

    // if (chapterId == null && bookId == null) {
    //   rawVerses = await (await DatabaseRetriever.instance.db)
    //     .query("verse", columns: ["id", "book_id", "chapter", "verse", "text"]);
    // }
    */

    for (final item in rawVerses) {
      verses.add(Verse.fromMap(item));
    }
    return verses;
  }
}
