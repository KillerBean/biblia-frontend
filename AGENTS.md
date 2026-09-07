# AGENTS.md — Biblia Flutter App

## Commands

```bash
flutter pub get              # Install deps (run after pubspec.yaml changes)
flutter run                  # Run app
flutter analyze              # Static analysis
flutter test                 # All tests
flutter test test/path       # Single test file/dir
dart run build_runner build --delete-conflicting-outputs  # Regenerate mocks after @GenerateMocks changes
```

**Verification order:** `flutter pub get` → `flutter analyze` → `flutter test`

## Architecture

Clean Architecture + MVVM. Entry point: `lib/main.dart` → `ModularApp(module: AppModule())`.

```
lib/
├── core/          # DI (flutter_modular), utils, parsers
├── domain/        # Entities, abstract repository interfaces, use cases
├── data/          # SQLite local, Dio HTTP, repository implementations
└── presentation/  # ViewModels (ChangeNotifier), Views, Widgets
```

All DI bindings and routes in `lib/core/di/book_module.dart`. Access deps via `Modular.get<T>()`.

**Data flow:** ViewModel → UseCase → Repository (FallbackDatabaseRepository: remote API → SQLite fallback)

**Routes:** `/` (home) → `/book/:bookid` (chapters) → `/book/:bookid/:chapterid` (verses, supports `?highlight=` and `?verseId=` query params)

## Testing

- Mocks are generated via `build_runner` — **always regenerate after changing `@GenerateMocks`** or tests will fail with stale mocks
- Generated mocks live alongside test files as `*_test.mocks.dart`
- Domain and ViewModel tests never touch real SQLite or HTTP
- `test/widget_test.dart` is empty (commented-out scaffold) — don't rely on it
- Test layers: domain (no mocks) → ViewModel (mock repos) → repository (mock Dio + DB) → widget (mock ViewModel)

## Key Quirks

- **SQLite DB:** `assets/db/ARC.db` — tables: `testament`, `book`, `verse`. Uses `sqflite_common_ffi` for desktop support. `DatabaseRetriever` is a singleton — register as `Singleton` in Modular, not `Bind`.
- **Language:** App is in Portuguese (pt-BR). All UI strings and Bible content are Portuguese.
- **Reference parsing:** `lib/core/utils/reference_parser.dart` handles formats like "Gn 1:1-5", "João 3:16". Falls back to full-text search when no reference pattern matches.
- **State management:** ViewModels use `ChangeNotifier` + `AnimatedBuilder` (not Provider/Riverpod). Pattern: private state + public getters + `notifyListeners()`.
- **Remote API:** `BibliaRemoteDataSource` has default `baseUrl = 'http://localhost'` — known issue (see NEXT-STEPS).

## Existing Instruction Files

- `CLAUDE.md` — Detailed architecture, testing strategy, performance tips
- `NEXT-STEPS-2026-04-01.md` — Security roadmap and pending fixes (SQL injection, signing config, etc.)
- `GEMINI.md` — Gemini CLI scaffolding guide (partially aspirational, trust actual code over this)
