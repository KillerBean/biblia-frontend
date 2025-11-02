import 'package:biblia/domain/repositories/database_repository.dart';
import 'package:biblia/domain/usecases/get_verses_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_verses_usecase_test.mocks.dart';

@GenerateMocks([DatabaseRepository])
void main() {
  late GetVersesUseCase getVersesUseCase;
  late MockDatabaseRepository mockDatabaseRepository;

  setUp(() {
    mockDatabaseRepository = MockDatabaseRepository();
    getVersesUseCase = GetVersesUseCase(mockDatabaseRepository);
  });

  group('GetVersesUseCase', () {
    test('should call getVerses on the repository', () async {
      // Arrange
      when(mockDatabaseRepository.getVerses(bookId: 1, chapterId: 1))
          .thenAnswer((_) async => []);

      // Act
      await getVersesUseCase.call(bookId: 1, chapterId: 1);

      // Assert
      verify(mockDatabaseRepository.getVerses(bookId: 1, chapterId: 1));
    });
  });
}
