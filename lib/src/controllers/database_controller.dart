// ignore_for_file: unused_local_variable

import 'package:biblia/src/models/book.dart';
import 'package:biblia/src/models/testament.dart';
import 'package:biblia/src/models/verse.dart';
import 'package:biblia/src/repositories/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DatabaseController with ChangeNotifier {
  final DatabaseRepository _databaseRepository =
      Modular.get<DatabaseRepository>();

  List<Book> _books = [];
  List<Verse> _verses = [];
  int _chapters = 0;
  List<Testament> _testaments = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Book> get books => _books;
  List<Verse> get verses => _verses;
  int get numChapters => _chapters;
  List<Testament> get testaments => _testaments;

  Future<void> getBooks() async {
    _isLoading = true;
    String error;

    try {
      _books = await _databaseRepository.getBooks();
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getVerses({int? bookId, int? chapterId}) async {
    _isLoading = true;
    String error;
    try {
      _verses = await _databaseRepository.getVerses(
          bookId: bookId, chapterId: chapterId);
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getChapters({required int bookId}) async {
    _isLoading = true;
    String error;
    try {
      _chapters = await _databaseRepository.getChapters(bookId: bookId);
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTestaments() async {
    _isLoading = true;
    String error;
    try {
      _testaments = await _databaseRepository.getTestaments();
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
