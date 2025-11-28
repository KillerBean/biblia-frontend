import 'package:biblia/domain/usecases/get_chapters_usecase.dart';
import 'package:biblia/presentation/viewmodels/chapter_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chapter_viewmodel_test.mocks.dart';

@GenerateMocks([GetChaptersUseCase])
void main() {
  late ChapterViewModel chapterViewModel;
  late MockGetChaptersUseCase mockGetChaptersUseCase;

  setUp(() {
    mockGetChaptersUseCase = MockGetChaptersUseCase();
    chapterViewModel = ChapterViewModel(mockGetChaptersUseCase);
  });

  group('ChapterViewModel', () {
    test('getChapters should call GetChaptersUseCase and update chapters count',
        () async {
      // Arrange
      when(mockGetChaptersUseCase.call(bookId: 1)).thenAnswer((_) async => 10);

      // Act
      await chapterViewModel.getChapters(bookId: 1);

      // Assert
      expect(chapterViewModel.numChapters, equals(10));
      verify(mockGetChaptersUseCase.call(bookId: 1));
    });

    test('isLoading should be true while fetching data', () {
      // Arrange
      when(mockGetChaptersUseCase.call(bookId: 1)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 10;
      });

      // Act
      final future = chapterViewModel.getChapters(bookId: 1);

      // Assert
      expect(chapterViewModel.isLoading, isTrue);

      // Act
      future.whenComplete(() {
        // Assert
        expect(chapterViewModel.isLoading, isFalse);
      });
    });

    test('getChapters should set errorMessage when an exception occurs', () async {
      // Arrange
      final exception = Exception('Database error');
      when(mockGetChaptersUseCase.call(bookId: 1)).thenThrow(exception);

      // Act
      await chapterViewModel.getChapters(bookId: 1);

      // Assert
      expect(chapterViewModel.numChapters, 0);
      expect(chapterViewModel.errorMessage, contains('Falha ao carregar capítulos'));
      expect(chapterViewModel.isLoading, isFalse);
    });
  });
}
