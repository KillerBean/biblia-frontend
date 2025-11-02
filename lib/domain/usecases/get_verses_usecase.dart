import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/entities/verse.dart';

class GetVersesUseCase {
  final DatabaseRepository repository;

  GetVersesUseCase(this.repository);

  Future<List<Verse>> call({int? bookId, int? chapterId}) async {
    return await repository.getVerses(bookId: bookId, chapterId: chapterId);
  }
}
