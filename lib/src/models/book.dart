class Book {
  int id;
  int bookReferenceId;
  int testamentReferenceId;
  String name;

  Book({
    required this.id,
    required this.bookReferenceId,
    required this.testamentReferenceId,
    required this.name,
  });

  Book.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        bookReferenceId = res["book_reference_id"],
        testamentReferenceId = res["testament_reference_id"],
        name = res["name"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'bookReferenceId': bookReferenceId,
      'testamentReferenceId': testamentReferenceId,
      'name': name
    };
  }
}
