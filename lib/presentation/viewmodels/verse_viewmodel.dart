import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/usecases/get_verses_usecase.dart';
import 'package:flutter/material.dart';

class VerseViewModel extends ChangeNotifier {
  final GetVersesUseCase _getVersesUseCase;

  VerseViewModel(this._getVersesUseCase);

  List<Verse> _verses = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Verse> get verses => _verses;

  Future<void> getVerses({int? bookId, int? chapterId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _verses = await _getVersesUseCase(bookId: bookId, chapterId: chapterId);
    } catch (e) {
      _errorMessage = "Falha ao carregar versículos: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
