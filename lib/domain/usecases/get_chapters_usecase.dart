import 'package:biblia/domain/repositories/database_repository.dart';

class GetChaptersUseCase {
  final DatabaseRepository repository;

  GetChaptersUseCase(this.repository);

  Future<int> call({required int bookId}) async {
    return await repository.getChapters(bookId: bookId);
  }
}
