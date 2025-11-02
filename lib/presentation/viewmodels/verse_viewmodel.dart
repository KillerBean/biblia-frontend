import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/usecases/get_verses_usecase.dart';
import 'package:flutter/material.dart';

class VerseViewModel extends ChangeNotifier {
  final GetVersesUseCase _getVersesUseCase;

  VerseViewModel(this._getVersesUseCase);

  List<Verse> _verses = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Verse> get verses => _verses;

  Future<void> getVerses({int? bookId, int? chapterId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _verses =
          await _getVersesUseCase(bookId: bookId, chapterId: chapterId);
    } catch (e) {
          // TODO: Handle error
        } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}