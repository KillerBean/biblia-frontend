import 'package:biblia/domain/entities/book.dart';
import 'package:biblia/domain/entities/testament.dart';
import 'package:biblia/domain/usecases/get_books_usecase.dart';
import 'package:biblia/domain/usecases/get_testaments_usecase.dart';
import 'package:flutter/material.dart';

class BookViewModel extends ChangeNotifier {
  final GetBooksUseCase _getBooksUseCase;
  final GetTestamentsUseCase _getTestamentsUseCase;

  BookViewModel(this._getBooksUseCase, this._getTestamentsUseCase);

  List<Book> _books = [];
  List<Testament> _testaments = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Book> get books => _books;
  List<Testament> get testaments => _testaments;

  Future<void> getBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _books = await _getBooksUseCase();
    } catch (e) {
      // TODO: Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTestaments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _testaments = await _getTestamentsUseCase();
    } catch (e) {
      // TODO: Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
