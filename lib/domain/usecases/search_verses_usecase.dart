import 'package:biblia/domain/entities/verse.dart';
import 'package:biblia/domain/repositories/database_repository.dart';

class SearchVersesUseCase {
  final DatabaseRepository _repository;

  SearchVersesUseCase(this._repository);

  Future<List<Verse>> call(String query) async {
    // 1. Tentar parsear como referências (suporta múltiplas separadas por ;)
    final references = _parseReferences(query);

    if (references.isNotEmpty) {
      final List<Verse> results = [];
      bool foundAnyReference = false;

      for (final ref in references) {
        final book = await _repository.findBook(ref.bookName);
        if (book != null) {
          foundAnyReference = true;
          final verses = await _repository.getVersesByRange(
            bookId: book.id,
            chapter: ref.chapter,
            startVerse: ref.startVerse,
            endVerse: ref.endVerse,
          );
          results.addAll(verses);
        }
      }

      if (foundAnyReference) {
        return results;
      }
    }

    // 2. Se não encontrou formato de referência ou não achou os livros, busca por texto
    return _repository.searchVerses(query);
  }

  List<_ParsedReference> _parseReferences(String query) {
    final List<_ParsedReference> refs = [];
    final parts = query.split(';');

    // Regex para capturar:
    // Group 1: Nome do livro (pode ter espaços, números no inicio ex: 1 Reis)
    // Group 2: Capítulo
    // Group 3: Versículo inicial (opcional)
    // Group 4: Versículo final (opcional)
    // Ex: "Salmo 23:1-4", "Jo 3:16", "Mateus 5"
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

        refs.add(_ParsedReference(bookName, chapter, startVerse, endVerse));
      }
    }
    return refs;
  }
}

class _ParsedReference {
  final String bookName;
  final int chapter;
  final int? startVerse;
  final int? endVerse;

  _ParsedReference(this.bookName, this.chapter, this.startVerse, this.endVerse);
}
