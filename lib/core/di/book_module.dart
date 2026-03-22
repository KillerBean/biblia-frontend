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

class BookModule extends Module {
  @override
  void binds(i) {
    // Config and Network
    i.addLazySingleton<ConfigService>(SharedPrefConfigService.new);
    i.addLazySingleton(() {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
      ));
      dio.interceptors.add(HttpsInterceptor());
      return dio;
    });
    i.addLazySingleton(BibliaRemoteDataSource.new);

    // Repository
    i.addLazySingleton<DatabaseRepository>(FallbackDatabaseRepository.new);

    // UseCases
    i.addLazySingleton(GetBooksUseCase.new);
    i.addLazySingleton(GetTestamentsUseCase.new);
    i.addLazySingleton(GetChaptersUseCase.new);
    i.addLazySingleton(GetVersesUseCase.new);
    i.addLazySingleton(SearchVersesUseCase.new);

    // ViewModels
    i.add(() => BookViewModel(i.get(), i.get()));
    i.add(() => ChapterViewModel(i.get()));
    i.add(() => VerseViewModel(i.get()));
    i.add(() => SearchViewModel(i.get()));
  }

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const HomePageWidget(title: "Bíblia Sagrada"));
    r.child('/book/:bookid', child: (context) {
      final bookId = int.tryParse(r.args.params["bookid"] ?? '') ?? 0;
      if (bookId <= 0) return const SizedBox.shrink();
      return BookPageWidget(bookId: bookId);
    });
    r.child('/book/:bookid/:chapterid', child: (context) {
      final bookId = int.tryParse(r.args.params["bookid"] ?? '') ?? 0;
      final chapterId = int.tryParse(r.args.params["chapterid"] ?? '') ?? 0;
      if (bookId <= 0 || chapterId <= 0) return const SizedBox.shrink();

      final highlightParam = r.args.queryParams['highlight'];
      final verseIdParam = r.args.queryParams['verseId'];

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
          bookId: bookId,
          chapterId: chapterId,
          highlightedVerses: highlights);
    });
  }
}
