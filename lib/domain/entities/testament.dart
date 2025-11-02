class Testament {
  int id;
  String name;

  Testament({required this.id, required this.name});

  Testament.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }
}
