# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Biblia is a Flutter Bible reading app that displays scripture from a local SQLite database (ARC.db) with optional remote API fallback. It supports browsing books/chapters/verses, Bible reference parsing, and full-text search.

## Common Commands

```bash
# Run the app
flutter run

# Run all tests
flutter test

# Run a single test file
flutter test test/domain/usecases/get_books_usecase_test.dart

# Generate mocks (required after changing @GenerateMocks annotations)
dart run build_runner build

# Analyze code
flutter analyze

# Get dependencies
flutter pub get
```

## Architecture

The app follows **Clean Architecture** with **MVVM** for the presentation layer:

```
lib/
├── core/           # Cross-cutting: DI (flutter_modular), utilities
├── domain/         # Business logic: entities, repositories (abstract), use cases
├── data/           # Data access: local SQLite, remote Dio HTTP client, repository impl
└── presentation/   # UI: ViewModels (ChangeNotifier), views, widgets
```

### Dependency Injection

Uses `flutter_modular`. All bindings are in `lib/core/di/book_module.dart`. Access dependencies via `Modular.get<T>()`.

### State Management

ViewModels extend `ChangeNotifier` and are consumed with `AnimatedBuilder`. Pattern:
- Private state (`_isLoading`, `_data`, `_errorMessage`)
- Public getters
- `notifyListeners()` triggers rebuilds

### Data Flow

1. **FallbackDatabaseRepository** attempts remote API first (if enabled), falls back to local SQLite
2. **Use Cases** encapsulate single operations (GetBooksUseCase, SearchVersesUseCase, etc.)
3. **ViewModels** call use cases and manage UI state

### Navigation

Routes defined in `book_module.dart`:
- `/` → Home
- `/book/:bookid` → Chapter grid
- `/book/:bookid/:chapterid` → Verse list (supports `?highlight=1,2,3` query param)

### Database

SQLite database `assets/db/ARC.db` contains tables: `testament`, `book`, `verse`. The `DatabaseRetriever` (singleton) handles cross-platform initialization including desktop support via `sqflite_common_ffi`.

### Search

`ReferenceParser` in `lib/core/utils/reference_parser.dart` handles Bible reference formats (e.g., "Gn 1:1-5", "João 3:16"). Falls back to full-text search when no reference pattern matches.

## Testing

| Nível | O que testa | Mocks | Ferramentas |
|-------|-------------|-------|-------------|
| **Unit — domínio** | Use cases, entidades, parsers puros | ❌ | flutter_test |
| **Unit — ViewModels** | ChangeNotifier state transitions | ✅ mock de repositórios | mockito |
| **Unit — repositórios** | FallbackDatabaseRepository, lógica de fallback | ✅ mock de Dio e DB | mockito |
| **Widget** | Componentes de UI isolados | ✅ mock de ViewModel | flutter_test |

Mocks gerados via `build_runner` — sempre rodar após alterar `@GenerateMocks`:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Regra: testes de domínio e ViewModel nunca tocam SQLite real nem HTTP.

## Performance (Flutter)

- Use `const` em todos os widgets que não têm estado variável
- Prefira `AnimatedBuilder` sobre `setState` amplo — scope o rebuild ao mínimo
- `FutureBuilder`/`StreamBuilder`: inclua `initialData` para evitar flash de loading
- Imagens: use `Image.asset` com `cacheWidth`/`cacheHeight` para decodificação menor
- Evite reconstruir o `DatabaseRetriever` — é singleton; garanta que o módulo o registre como `Singleton` (não `Bind`)
- `RepaintBoundary` em animações pesadas que não precisam repintar o resto da árvore

## Language

The app is in Portuguese (pt-BR). UI strings and Bible content are in Portuguese.
