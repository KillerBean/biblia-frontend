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
import 'package:flutter_modular/flutter_modular.dart';

class BookModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<DatabaseRepository>(FallbackDatabaseRepository.new);
    i.addLazySingleton(GetBooksUseCase.new);
    i.addLazySingleton(GetTestamentsUseCase.new);
    i.addLazySingleton(GetChaptersUseCase.new);
    i.addLazySingleton(GetVersesUseCase.new);
    i.addLazySingleton(SearchVersesUseCase.new);
    i.add(() => BookViewModel(i.get(), i.get()));
    i.add(() => ChapterViewModel(i.get()));
    i.add(() => VerseViewModel(i.get()));
    i.add(() => SearchViewModel(i.get()));
  }

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const HomePageWidget(title: "Bíblia Sagrada"));
    r.child('/book/:bookid',
        child: (context) =>
            BookPageWidget(bookId: int.parse(r.args.params["bookid"])));
    r.child('/book/:bookid/:chapterid',
        child: (context) => ChapterPageWidget(
            bookId: int.parse(r.args.params["bookid"]),
            chapterId: int.parse(r.args.params["chapterid"])));
  }
}
