import 'package:biblia/domain/usecases/get_chapters_usecase.dart';
import 'package:flutter/material.dart';

class ChapterViewModel extends ChangeNotifier {
  final GetChaptersUseCase _getChaptersUseCase;

  ChapterViewModel(this._getChaptersUseCase);

  int _chapters = 0;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get numChapters => _chapters;

  Future<void> getChapters({required int bookId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _chapters = await _getChaptersUseCase(bookId: bookId);
    } catch (e) {
      _errorMessage = "Falha ao carregar capítulos: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}