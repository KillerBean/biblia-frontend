import 'package:biblia/src/models/book.dart';
import 'package:biblia/src/models/testament.dart';
import 'package:biblia/src/models/verse.dart';
import 'package:biblia/src/repos/db/db.dart';
import 'package:biblia/src/repositories/database_repository.dart';

class FallbackDatabaseRepository extends DatabaseRepository {
  @override
  Future<List<Book>> getBooks() async {
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
  Future<List<Verse>> getVerses() async {
    List<Verse> verses = [];
    final rawVerses = await (await DatabaseRetriever.instance.db)
        .query("book", columns: ["id", "book_id", "chapter", "verse", "text"]);
    for (final item in rawVerses) {
      verses.add(Verse.fromMap(item));
    }
    return verses;
  }
}
