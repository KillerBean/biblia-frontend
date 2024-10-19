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
  List<Testament> _testaments = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Book> get books => _books;
  List<Verse> get verses => _verses;
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

  Future<void> getVerses() async {
    _isLoading = true;
    String error;
    try {
      _verses = await _databaseRepository.getVerses();
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
