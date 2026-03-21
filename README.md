# Biblia — Leitor de Bíblia Flutter

Uma app Flutter para leitura de Bíblia com suporte offline (SQLite local) e API remota. Busca avançada (referências bíblicas + full-text), navegação por livros/capítulos/versículos, seleção/cópia, e análise de referências.

**Arquitetura**: Clean Architecture + MVVM | **Testes**: Unit, Widget | **Banco**: SQLite + fallback remoto

---

## 🚀 Início Rápido

```bash
# Clonar e instalar
git clone <repo>
cd biblia_front
flutter pub get

# Executar app
flutter run

# Rodar testes
flutter test

# Análise estática
flutter analyze
```

---

## 📋 Testes

```bash
flutter test                           # Todos os testes
flutter test test/domain/usecases/     # Apenas use cases
dart run build_runner build            # Gerar mocks (após @GenerateMocks)
```

Veja [CLAUDE.md](CLAUDE.md#testing) para estratégia de testes detalhada.

---

## 🏗️ Arquitetura

**Clean Architecture** + **MVVM** para presentation:

```
lib/
├── core/              # Cross-cutting: DI (flutter_modular), utils, parsers
├── domain/            # Business logic: entities, repositories (abstract), use cases
├── data/              # Data layer: SQLite local, Dio HTTP, repository impl
└── presentation/      # UI: ViewModels (ChangeNotifier), Views, Widgets
```

### Fluxo de Dados

1. **Use Case** encapsula operação de negócio
2. **ViewModel** chama use case e gerencia UI state
3. **View** (widget) observa ViewModel via AnimatedBuilder
4. **Repository** implementa fallback: API remota → SQLite local

### Injeção de Dependência

Tudo em `lib/core/di/book_module.dart`:
```dart
Modular.get<GetBooksUseCase>()
```

---

## ✨ Features

| Feature | Status | Detalhes |
|---------|--------|----------|
| Navegação | ✅ | books → chapters → verses |
| Busca Full-Text | ✅ | Por conteúdo de versículos |
| Referências Bíblicas | ✅ | Parser (Gn 1:1-5, João 3:16, etc.) |
| Seleção/Cópia | ✅ | Selecionar e copiar versículos |
| API Remota | ✅ | Fallback automático quando offline |
| Testes | ✅ | Unit + Widget com mockito |
| Documentação | ✅ | CLAUDE.md, TODO.md, CHANGELOG.md |
| 🚧 Bookmarks | 📋 | Marcadores (planejado — veja TODO.md) |

---

## 📚 Documentação

- **[CLAUDE.md](CLAUDE.md)** — Arquitetura, padrões, testing, performance
- **[TODO.md](TODO.md)** — Roadmap e tasks pendentes
- **[CHANGELOG.md](CHANGELOG.md)** — Histórico completo de mudanças
- **[GEMINI.md](GEMINI.md)** — Notas de pesquisa (Gemini integration)
- **[next-steps.md](next-steps.md)** — Próximos passos técnicos

---

## 🛠️ Stack Técnico

- **Framework**: Flutter 3.x
- **State**: ChangeNotifier + AnimatedBuilder
- **DI**: flutter_modular
- **Database**: SQLite (sqflite + sqflite_common_ffi para desktop)
- **HTTP**: Dio
- **Testes**: flutter_test, mockito
- **Build**: build_runner (mocks)

---

## 🔗 Banco de Dados

- **Arquivo**: `assets/db/ARC.db` (SQLite)
- **Tabelas**: `testament`, `book`, `verse`
- **Suporte**: Android, iOS, Web, Desktop (via sqflite_common_ffi)
- **Fallback**: API remota quando offline

---

## 🌐 Plataformas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Desktop (Linux, macOS, Windows)

---

## 📝 Linguagem

App em **Português (pt-BR)**. Bíblia em Português (ARC).

---

## 👤 Contribuindo

Veja [CLAUDE.md](CLAUDE.md) para guidelines de code style, testing, e commits.

---

**Último update**: 2026-03-21 | Veja [CHANGELOG.md](CHANGELOG.md) para histórico completo
