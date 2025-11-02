import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/entities/testament.dart';

class GetTestamentsUseCase {
  final DatabaseRepository repository;

  GetTestamentsUseCase(this.repository);

  Future<List<Testament>> call() async {
    return await repository.getTestaments();
  }
}
