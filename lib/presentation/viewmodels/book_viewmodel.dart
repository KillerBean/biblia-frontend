import 'package:biblia/core/utils/app_error_handler.dart';
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
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Book> get books => _books;
  List<Testament> get testaments => _testaments;

  Future<void> getBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _books = await _getBooksUseCase();
    } catch (e, st) {
      AppErrorHandler.log(e, st, context: 'BookViewModel.getBooks');
      _errorMessage = AppErrorHandler.toUserMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTestaments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _testaments = await _getTestamentsUseCase();
    } catch (e, st) {
      AppErrorHandler.log(e, st, context: 'BookViewModel.getTestaments');
      _errorMessage = AppErrorHandler.toUserMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
