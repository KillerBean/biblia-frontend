# Biblia

Uma app Flutter para leitura de Bíblia com suporte offline e API remota. Busca, navegação por livros/capítulos/versículos, análise de referências bíblicas e marcadores.

## Início rápido

```bash
flutter pub get
flutter run
```

## Testes

```bash
flutter test                    # Todos os testes
flutter analyze                 # Análise estática
dart run build_runner build     # Gerar mocks após alterações
```

## Arquitetura

Clean Architecture + MVVM. Veja [CLAUDE.md](CLAUDE.md) para detalhes.

```
lib/
├── core/           # DI (flutter_modular), utilitários
├── domain/         # Use cases, entidades, repositórios abstratos
├── data/           # SQLite local, Dio HTTP, implementações
└── presentation/   # UI, ViewModels (ChangeNotifier)
```

## Status

- ✅ Navegação (livros → capítulos → versículos)
- ✅ Busca (referências bíblicas + full-text)
- ✅ Toggle API/offline
- ✅ Seleção e cópia de versículos
- 🚧 Veja [TODO.md](TODO.md) para features pendentes
