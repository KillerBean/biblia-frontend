import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/entities/testament.dart';

abstract class DatabaseRepository {
  Future<List<Book>> getBooks({int? testament});
  Future<int> getChapters({required int bookId});
  Future<List<Verse>> getVerses({int? bookId, int? chapterId});
  Future<List<Testament>> getTestaments();
}
