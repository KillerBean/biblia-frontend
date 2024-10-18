import 'package:biblia/src/models/book.dart';
import 'package:biblia/src/models/testament.dart';
import 'package:biblia/src/models/verse.dart';
import 'package:biblia/src/repositories/database_repository.dart';
import 'package:flutter/material.dart';

class DatabaseController extends ChangeNotifier {
  final DatabaseRepository databaseRepository;
  DatabaseController(this.databaseRepository);

  List<Book> _books = [];
  List<Verse> _verses = [];
  List<Testament> _testaments = [];

  List<Book> get books => _books;
  List<Verse> get verses => _verses;
  List<Testament> get testaments => _testaments;

  Future<void> getBooks() async {
    bool isLoading = true;
    var error = null;

    try {
      _books = await databaseRepository.getBooks();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getVerses() async {
    bool isLoading = true;
    var error = null;
    try {
      _verses = await databaseRepository.getVerses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTestaments() async {
    bool isLoading = true;
    var error = null;
    try {
      _testaments = await databaseRepository.getTestaments();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
