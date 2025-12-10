import 'package:flutter_test/flutter_test.dart';
import 'package:biblia/domain/entities/verse.dart';

void main() {
  group('Verse', () {
    test('fromMap should parse correctly with flat structure', () {
      final map = {
        'id': 1,
        'book_id': 10,
        'chapter': 1,
        'verse': 1,
        'text': 'In the beginning...',
        'book_name': 'Genesis',
      };

      final verse = Verse.fromMap(map);

      expect(verse.id, 1);
      expect(verse.bookId, 10);
      expect(verse.chapter, 1);
      expect(verse.verse, 1);
      expect(verse.text, 'In the beginning...');
      expect(verse.bookName, 'Genesis');
    });

    test('fromMap should parse correctly with nested book structure (API improvement)', () {
      final map = {
        'id': 2,
        'chapter': 2,
        'verse': 5,
        'text': 'And the earth...',
        'book': {
          'id': 20,
          'name': 'Exodus',
        }
      };

      final verse = Verse.fromMap(map);

      expect(verse.id, 2);
      expect(verse.bookId, 20); // Should be extracted from nested book.id
      expect(verse.chapter, 2);
      expect(verse.verse, 5);
      expect(verse.text, 'And the earth...');
      expect(verse.bookName, 'Exodus'); // Should be extracted from nested book.name
    });

    test('fromMap should prioritize top-level fields if both exist', () {
      final map = {
        'id': 3,
        'book_id': 30,
        'chapter': 3,
        'verse': 10,
        'text': 'Test text',
        'book_name': 'Leviticus',
        'book': {
          'id': 99, // Should be ignored
          'name': 'Ignored', // Should be ignored
        }
      };

      final verse = Verse.fromMap(map);

      expect(verse.bookId, 30);
      expect(verse.bookName, 'Leviticus');
    });

    test('fromMap should throw or fail gracefully if bookId is missing in both places', () {
       final map = {
        'id': 4,
        'chapter': 4,
        'verse': 1,
        'text': 'Missing book id',
      };

      // Since bookId is non-nullable in Verse constructor (it seems, let's check Verse definition again implicitly via this test), 
      // accessing it might throw if the extraction logic results in null passed to a required int.
      // In the current implementation: 
      // bookId = res["book_id"] ?? res['book']?['id']
      // If both are null, bookId will be null.
      // If the Verse constructor defines `required int bookId`, then passing null will be a runtime error or cast error.
      // Let's verify what happens. 
      
      expect(() => Verse.fromMap(map), throwsA(isA<TypeError>()));
    });
  });
}
