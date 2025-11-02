import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/usecases/get_testaments_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_testaments_usecase_test.mocks.dart';

@GenerateMocks([DatabaseRepository])
void main() {
  late GetTestamentsUseCase getTestamentsUseCase;
  late MockDatabaseRepository mockDatabaseRepository;

  setUp(() {
    mockDatabaseRepository = MockDatabaseRepository();
    getTestamentsUseCase = GetTestamentsUseCase(mockDatabaseRepository);
  });

  group('GetTestamentsUseCase', () {
    test('should call getTestaments on the repository', () async {
      // Arrange
      when(mockDatabaseRepository.getTestaments()).thenAnswer((_) async => []);

      // Act
      await getTestamentsUseCase.call();

      // Assert
      verify(mockDatabaseRepository.getTestaments());
    });
  });
}
