class Bible {
  int bookReferenceId;
  int testamentReferenceId;
  String name;

  Bible({
    required this.bookReferenceId,
    required this.testamentReferenceId,
    required this.name,
  });

  Bible.fromMap(Map<String, dynamic> res)
      : bookReferenceId = res["book_reference_id"],
        testamentReferenceId = res["testament_reference_id"],
        name = res["name"];

  Map<String, Object?> toMap() {
    return {
      'bookReferenceId': bookReferenceId,
      'testamentReferenceId': testamentReferenceId,
      'name': name
    };
  }
}
