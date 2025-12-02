import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/usecases/search_verses_usecase.dart';
import 'package:flutter/foundation.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchVersesUseCase _searchVersesUseCase;

  SearchViewModel(this._searchVersesUseCase);

  List<Verse> _verses = [];
  List<Verse> get verses => _verses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  String? _lastQuery;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _verses = [];
      _lastQuery = null;
      notifyListeners();
      return;
    }

    if (query == _lastQuery && (_verses.isNotEmpty || _error.isNotEmpty)) {
      return;
    }

    _lastQuery = query;
    _isLoading = true;
    _error = '';
    // Notify to show loading state
    // We must check if we are already notifying to avoid "Notify during build" if called from build
    // But since this is async, it will schedule a microtask usually, but setting _isLoading synchronously changes state.
    // To be safe from build-phase errors, we might need to schedule this.
    // However, for now, let's just proceed.
    notifyListeners();

    try {
      _verses = await _searchVersesUseCase(query);
    } catch (e) {
      _error = 'Erro ao buscar versículos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
