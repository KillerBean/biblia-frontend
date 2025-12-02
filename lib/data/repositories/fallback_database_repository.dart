import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/data/datasources/local/local_sqlite.dart';
import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FallbackDatabaseRepository extends DatabaseRepository {
  final Future<Database> Function() _dbProvider;

  FallbackDatabaseRepository({Future<Database> Function()? dbProvider})
      : _dbProvider = dbProvider ?? (() => DatabaseRetriever.instance.db);

  @override
  Future<List<Book>> getBooks({int? testament}) async {
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
    final db = await _dbProvider();
    final rawVerses = await db.rawQuery(
        "SELECT * FROM verse WHERE book_id = ? GROUP BY chapter", [bookId]);

    return rawVerses.length;
  }

  @override
  Future<Book?> findBook(String name) async {
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

    // Tenta encontrar correspondência em qualquer parte (útil para "João" achar "1 João" se desejado,
    // mas arriscado. Vamos manter prefixo primeiro.
    // Se não achou prefixo, tenta contains, mas prioriza livros menores?
    // Por enquanto simples prefix match.
    return null;
  }

  @override
  Future<List<Verse>> getVersesByRange({
    required int bookId,
    required int chapter,
    int? startVerse,
    int? endVerse,
  }) async {
    List<Verse> verses = [];
    final db = await _dbProvider();
    String sql =
        "SELECT v.*, b.name as book_name FROM verse v JOIN book b ON v.book_id = b.id WHERE v.book_id = ? AND v.chapter = ?";
    List<dynamic> args = [bookId, chapter];

    if (startVerse != null) {
      sql += " AND v.verse >= ?";
      args.add(startVerse);
    }

    if (endVerse != null) {
      sql += " AND v.verse <= ?";
      args.add(endVerse);
    } else if (startVerse != null) {
      // Se tem startVerse mas não endVerse, assumimos que é só aquele versículo?
      // O prompt diz: "Jo 1:5" -> só o 5.
      // Mas "Jo 1:5-10" -> 5 ao 10.
      // Se startVerse é passado e endVerse null, vamos assumir que queremos APENAS o startVerse.
      // Para pegar "do X em diante", teríamos que ter uma flag explícita, mas o padrão "Cap:Verso" é único.
      // Porém, se eu quiser "ler do 5 em diante", o usuário digitaria "5-". O parser deve lidar com isso.
      // Aqui, vou assumir: se start != null e end == null, é single verse match.
      sql += " AND v.verse = ?"; // Redundante se já tem >=, mas para garantir igualdade
      // Ops, lógica acima:
      // Range "5-10": start=5, end=10 -> >= 5 AND <= 10.
      // Single "5": start=5, end=null -> quero SÓ o 5.
      // Então:
      // if (endVerse == null) sql += " AND v.verse = startVerse" effectively.
      // Corrigindo lógica:
    }

    // Re-implementando lógica de range correta
    sql =
        "SELECT v.*, b.name as book_name FROM verse v JOIN book b ON v.book_id = b.id WHERE v.book_id = ? AND v.chapter = ?";
    args = [bookId, chapter];

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
        rawVerses = await db.rawQuery("SELECT * FROM verse WHERE book_id = ?", [bookId]);
      }
      if (chapterId != null) {
        //busca todos os versículos de um livro e capítulo específicos
        rawVerses = await db.rawQuery(
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

  @override
  Future<List<Verse>> searchVerses(String query) async {
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
