import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/usecases/get_verses_usecase.dart';
import 'package:biblia/presentation/viewmodels/verse_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verse_viewmodel_test.mocks.dart';

@GenerateMocks([GetVersesUseCase])
void main() {
  late VerseViewModel verseViewModel;
  late MockGetVersesUseCase mockGetVersesUseCase;

  setUp(() {
    mockGetVersesUseCase = MockGetVersesUseCase();
    verseViewModel = VerseViewModel(mockGetVersesUseCase);
  });

  group('VerseViewModel', () {
    test('getVerses should call GetVersesUseCase and update verses list',
        () async {
      // Arrange
      final verses = [Verse(id: 1, bookId: 1, chapter: 1, verse: 1, text: 'In the beginning...')];
      when(mockGetVersesUseCase.call(bookId: 1, chapterId: 1))
          .thenAnswer((_) async => verses);

      // Act
      await verseViewModel.getVerses(bookId: 1, chapterId: 1);

      // Assert
      expect(verseViewModel.verses, equals(verses));
      verify(mockGetVersesUseCase.call(bookId: 1, chapterId: 1));
    });

    test('isLoading should be true while fetching data', () {
      // Arrange
      when(mockGetVersesUseCase.call(bookId: 1, chapterId: 1)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      // Act
      final future = verseViewModel.getVerses(bookId: 1, chapterId: 1);

      // Assert
      expect(verseViewModel.isLoading, isTrue);

      // Act
      future.whenComplete(() {
        // Assert
        expect(verseViewModel.isLoading, isFalse);
      });
    });

    test('getVerses should set errorMessage when an exception occurs', () async {
      // Arrange
      final exception = Exception('Database error');
      when(mockGetVersesUseCase.call(bookId: 1, chapterId: 1)).thenThrow(exception);

      // Act
      await verseViewModel.getVerses(bookId: 1, chapterId: 1);

      // Assert
      expect(verseViewModel.verses, isEmpty);
      expect(verseViewModel.errorMessage, contains('Falha ao carregar versículos'));
      expect(verseViewModel.isLoading, isFalse);
    });
  });
}
