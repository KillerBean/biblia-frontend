import 'package:biblia/src/pages/lists/book.dart';
import 'package:biblia/src/pages/widgets/bookpage_widget.dart';
import 'package:biblia/src/pages/widgets/chapterpage_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BookModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const ListBooksPage());
    r.child('/:bookid',
        child: (context) =>
            BookPageWidget(bookId: int.parse(r.args.params["bookid"])));
    r.child('/:bookid/:chapterid',
        child: (context) => ChapterPageWidget(
            bookId: int.parse(r.args.params["bookid"]),
            chapterId: int.parse(r.args.params["chapterid"])));
  }
}
