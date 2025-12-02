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

  Verse.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        bookId = res["book_id"],
        chapter = res["chapter"],
        verse = res["verse"],
        text = res["text"],
        bookName = res["book_name"];

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
