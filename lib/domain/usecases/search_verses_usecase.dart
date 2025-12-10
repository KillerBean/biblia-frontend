import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/repositories/database_repository.dart';

class SearchVersesUseCase {
  final DatabaseRepository _repository;

  SearchVersesUseCase(this._repository);

  Future<List<Verse>> call(String query) async {
    return _repository.searchVerses(query);
  }
}