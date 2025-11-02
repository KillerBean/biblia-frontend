import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/entities/book.dart';

class GetBooksUseCase {
  final DatabaseRepository repository;

  GetBooksUseCase(this.repository);

  Future<List<Book>> call({int? testament}) async {
    return await repository.getBooks(testament: testament);
  }
}
