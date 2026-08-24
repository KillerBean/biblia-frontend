class Verse {
  int id;
  int bookId;
  int chapter;
  int verse;
  String text;
  String? bookName;

  Verse({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.text,
    this.bookName,
  });

  factory Verse.fromMap(Map<String, dynamic> res) {
    final nestedBook = res['book'] as Map<String, dynamic>?;

    return Verse(
      id: res['id'] as int,
      bookId: (res['book_id'] as int?) ?? (nestedBook?['id'] as int),
      chapter: res['chapter'] as int,
      verse: res['verse'] as int,
      text: res['text'] as String,
      bookName: (res['book_name'] as String?) ?? nestedBook?['name'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'book_name': bookName,
    };
  }
}
