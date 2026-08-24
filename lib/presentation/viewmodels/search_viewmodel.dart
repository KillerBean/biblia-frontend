import 'dart:async';

import 'package:biblia/core/utils/app_error_handler.dart';
import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/usecases/search_verses_usecase.dart';
import 'package:flutter/foundation.dart';

class SearchViewModel extends ChangeNotifier {
  static const int maxQueryLength = 200;
  static const Duration searchDebounce = Duration(milliseconds: 450);

  final SearchVersesUseCase _searchVersesUseCase;

  SearchViewModel(this._searchVersesUseCase);

  List<Verse> _verses = [];
  List<Verse> get verses => _verses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  String? _lastQuery;
  Timer? _debounce;
  int _requestVersion = 0;

  Future<void> search(String query) async {
    _debounce?.cancel();
    final requestVersion = ++_requestVersion;
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      _verses = [];
      _lastQuery = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (normalizedQuery.length > maxQueryLength) {
      _verses = [];
      _lastQuery = normalizedQuery;
      _isLoading = false;
      _error = 'Busca muito longa. Máximo de $maxQueryLength caracteres.';
      notifyListeners();
      return;
    }

    if (normalizedQuery == _lastQuery &&
        (_verses.isNotEmpty || _error.isNotEmpty)) {
      return;
    }

    _lastQuery = normalizedQuery;
    _isLoading = true;
    _error = '';
    notifyListeners();

    _debounce = Timer(searchDebounce, () {
      unawaited(_executeSearch(normalizedQuery, requestVersion));
    });
  }

  Future<void> _executeSearch(String query, int requestVersion) async {
    if (requestVersion != _requestVersion) return;

    try {
      final verses = await _searchVersesUseCase(query);
      if (requestVersion == _requestVersion) _verses = verses;
    } catch (e, st) {
      if (requestVersion == _requestVersion) {
        AppErrorHandler.log(e, st, context: 'SearchViewModel.search');
        _error = AppErrorHandler.toUserMessage(e);
      }
    } finally {
      if (requestVersion == _requestVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
