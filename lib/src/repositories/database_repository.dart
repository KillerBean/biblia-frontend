import 'package:biblia/src/models/book.dart';
import 'package:biblia/src/models/verse.dart';
import 'package:biblia/src/models/testament.dart';

abstract class DatabaseRepository {
  Future<List<Book>> getBooks();
  Future<List<Verse>> getVerses();
  Future<List<Testament>> getTestaments();
}
