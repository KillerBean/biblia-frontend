import 'package:biblia/core/utils/reference_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReferenceParser', () {
    test('should parse "Gn 1"', () {
      final refs = ReferenceParser.parse('Gn 1');
      expect(refs.length, 1);
      expect(refs.first.bookName, 'Gn');
      expect(refs.first.chapter, 1);
      expect(refs.first.startVerse, null);
      expect(refs.first.endVerse, null);
    });

    test('should parse "Genesis 1:1"', () {
      final refs = ReferenceParser.parse('Genesis 1:1');
      expect(refs.length, 1);
      expect(refs.first.bookName, 'Genesis');
      expect(refs.first.chapter, 1);
      expect(refs.first.startVerse, 1);
      expect(refs.first.endVerse, null);
    });

    test('should parse "John 3:16-18"', () {
      final refs = ReferenceParser.parse('John 3:16-18');
      expect(refs.length, 1);
      expect(refs.first.bookName, 'John');
      expect(refs.first.chapter, 3);
      expect(refs.first.startVerse, 16);
      expect(refs.first.endVerse, 18);
    });

    test('should parse "1 John 1:9"', () {
      final refs = ReferenceParser.parse('1 John 1:9');
      expect(refs.length, 1);
      expect(refs.first.bookName, '1 John');
      expect(refs.first.chapter, 1);
      expect(refs.first.startVerse, 9);
    });

     test('should parse multiple references "Gn 1; Ex 2"', () {
      final refs = ReferenceParser.parse('Gn 1; Ex 2');
      expect(refs.length, 2);
      expect(refs[0].bookName, 'Gn');
      expect(refs[1].bookName, 'Ex');
    });
  });
}
