import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/usecases/get_chapters_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_chapters_usecase_test.mocks.dart';

@GenerateMocks([DatabaseRepository])
void main() {
  late GetChaptersUseCase getChaptersUseCase;
  late MockDatabaseRepository mockDatabaseRepository;

  setUp(() {
    mockDatabaseRepository = MockDatabaseRepository();
    getChaptersUseCase = GetChaptersUseCase(mockDatabaseRepository);
  });

  group('GetChaptersUseCase', () {
    test('should call getChapters on the repository', () async {
      // Arrange
      when(mockDatabaseRepository.getChapters(bookId: 1)).thenAnswer((_) async => 10);

      // Act
      await getChaptersUseCase.call(bookId: 1);

      // Assert
      verify(mockDatabaseRepository.getChapters(bookId: 1));
    });
  });
}
