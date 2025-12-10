class ParsedReference {
  final String bookName;
  final int chapter;
  final int? startVerse;
  final int? endVerse;

  ParsedReference({
    required this.bookName,
    required this.chapter,
    this.startVerse,
    this.endVerse,
  });
  
  @override
  String toString() {
    String ref = '$bookName $chapter';
    if (startVerse != null) {
      ref += ':$startVerse';
      if (endVerse != null) {
        ref += '-$endVerse';
      }
    }
    return ref;
  }
}

class ReferenceParser {
  static List<ParsedReference> parse(String query) {
    final List<ParsedReference> refs = [];
    final parts = query.split(';');

    // Regex to match:
    // 1. Book name (allowing numbers at start like 1 John and spaces)
    // 2. Chapter number
    // 3. Optional start verse
    // 4. Optional end verse
    //
    // Matches:
    // "Gn 1"
    // "Gn 1:1"
    // "Gn 1:1-5"
    // "1 John 2:3"
    
    final regex = RegExp(
      r'^((?:\d\s*)?[a-zA-ZÀ-ÿ]+(?:\s+[a-zA-ZÀ-ÿ]+)*)\s+(\d+)(?::(\d+)(?:-(\d+))?)?$',
    );

    for (var part in parts) {
      part = part.trim();
      final match = regex.firstMatch(part);

      if (match != null) {
        final bookName = match.group(1)!.trim();
        final chapter = int.parse(match.group(2)!);
        final startVerse =
            match.group(3) != null ? int.parse(match.group(3)!) : null;
        final endVerse =
            match.group(4) != null ? int.parse(match.group(4)!) : null;

        refs.add(ParsedReference(
          bookName: bookName,
          chapter: chapter,
          startVerse: startVerse,
          endVerse: endVerse,
        ));
      }
    }

    return refs;
  }
}
