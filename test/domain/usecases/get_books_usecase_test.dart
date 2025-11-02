import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/usecases/get_books_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_books_usecase_test.mocks.dart';

@GenerateMocks([DatabaseRepository])
void main() {
  late GetBooksUseCase getBooksUseCase;
  late MockDatabaseRepository mockDatabaseRepository;

  setUp(() {
    mockDatabaseRepository = MockDatabaseRepository();
    getBooksUseCase = GetBooksUseCase(mockDatabaseRepository);
  });

  group('GetBooksUseCase', () {
    test('should call getBooks on the repository', () async {
      // Arrange
      when(mockDatabaseRepository.getBooks()).thenAnswer((_) async => []);

      // Act
      await getBooksUseCase.call();

      // Assert
      verify(mockDatabaseRepository.getBooks());
    });
  });
}
