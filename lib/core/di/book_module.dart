import 'package:biblia/core/utils/config_service.dart';
import 'package:biblia/core/utils/https_interceptor.dart';
import 'package:biblia/core/utils/shared_pref_config_service.dart';
import 'package:biblia/data/datasources/remote/biblia_remote_data_source.dart';
import 'package:biblia/data/repositories/fallback_database_repository.dart';
import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/usecases/get_books_usecase.dart';
import 'package:biblia/domain/usecases/get_chapters_usecase.dart';
import 'package:biblia/domain/usecases/get_testaments_usecase.dart';
import 'package:biblia/domain/usecases/get_verses_usecase.dart';
import 'package:biblia/domain/usecases/search_verses_usecase.dart';
import 'package:biblia/presentation/viewmodels/book_viewmodel.dart';
import 'package:biblia/presentation/viewmodels/chapter_viewmodel.dart';
import 'package:biblia/presentation/viewmodels/search_viewmodel.dart';
import 'package:biblia/presentation/viewmodels/verse_viewmodel.dart';
import 'package:biblia/presentation/widgets/bookpage_widget.dart';
import 'package:biblia/presentation/widgets/chapterpage_widget.dart';
import 'package:biblia/presentation/widgets/homepage_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Módulo sem `path`: binds no injetor raiz (vivem o app todo) e rotas na raiz.
final bookModule = createModule(register: (c) {
  // Config and Network
  c.addLazySingleton<ConfigService>(SharedPrefConfigService.new);
  c.addLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ));
    dio.interceptors.add(HttpsInterceptor());
    return dio;
  });
  c.addLazySingleton<BibliaRemoteDataSource>(() => BibliaRemoteDataSource(
        baseUrl: const String.fromEnvironment('API_BASE_URL'),
      ));

  // Repository
  c.addLazySingleton<DatabaseRepository>(FallbackDatabaseRepository.new);

  // UseCases
  c.addLazySingleton<GetBooksUseCase>(GetBooksUseCase.new);
  c.addLazySingleton<GetTestamentsUseCase>(GetTestamentsUseCase.new);
  c.addLazySingleton<GetChaptersUseCase>(GetChaptersUseCase.new);
  c.addLazySingleton<GetVersesUseCase>(GetVersesUseCase.new);
  c.addLazySingleton<SearchVersesUseCase>(SearchVersesUseCase.new);

  // ViewModels (factory: nova instância por tela)
  c.add<BookViewModel>(BookViewModel.new);
  c.add<ChapterViewModel>(ChapterViewModel.new);
  c.add<VerseViewModel>(VerseViewModel.new);
  c.add<SearchViewModel>(SearchViewModel.new);

  c.route('/',
      child: (context, state) =>
          const HomePageWidget(title: "Bíblia Sagrada"));
  c.route('/book/:bookid', child: (context, state) {
    final bookId = int.tryParse(state.params["bookid"] ?? '') ?? 0;
    if (bookId <= 0) return const SizedBox.shrink();
    return BookPageWidget(bookId: bookId);
  });
  c.route('/book/:bookid/:chapterid', child: (context, state) {
    final bookId = int.tryParse(state.params["bookid"] ?? '') ?? 0;
    final chapterId = int.tryParse(state.params["chapterid"] ?? '') ?? 0;
    if (bookId <= 0 || chapterId <= 0) return const SizedBox.shrink();

    final highlightParam = state.query['highlight'];
    final verseIdParam = state.query['verseId'];

    List<int>? highlights;
    if (highlightParam != null && highlightParam.isNotEmpty) {
      highlights = highlightParam
          .split(',')
          .map((e) => int.tryParse(e))
          .whereType<int>()
          .toList();
    } else if (verseIdParam != null && verseIdParam.isNotEmpty) {
      final v = int.tryParse(verseIdParam);
      if (v != null) highlights = [v];
    }

    return ChapterPageWidget(
        bookId: bookId, chapterId: chapterId, highlightedVerses: highlights);
  });
});
