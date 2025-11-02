import 'package:biblia/domain/usecases/get_chapters_usecase.dart';
import 'package:flutter/material.dart';

class ChapterViewModel extends ChangeNotifier {
  final GetChaptersUseCase _getChaptersUseCase;

  ChapterViewModel(this._getChaptersUseCase);

  int _chapters = 0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int get numChapters => _chapters;

  Future<void> getChapters({required int bookId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _chapters = await _getChaptersUseCase(bookId: bookId);
    } catch (e) {
          // TODO: Handle error
        } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}