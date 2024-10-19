import 'package:biblia/src/models/book.dart';
import 'package:biblia/src/models/verse.dart';
import 'package:biblia/src/models/testament.dart';

abstract class DatabaseRepository {
  Future<List<Book>> getBooks({int? testament});
  Future<List<Verse>> getVerses({int? chapter});
  Future<List<Testament>> getTestaments();
}
