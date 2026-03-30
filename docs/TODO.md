# TODO — Biblia Front

> Atualizado em 2026-03-30. Marque com `[x]` quando concluído.

---

## Segurança

### Crítico
- [x] `avoid_print` habilitado no lint (`analysis_options.yaml`)
- [x] `int.parse()` substituído por `int.tryParse()` nas rotas (`book_module.dart:61,66`)
- [x] Dio com timeouts configurados (`book_module.dart:28-36`)
- [x] ViewModels usando `AppErrorHandler.toUserMessage` (sem `$e` exposto na UI)
- [x] `AppLogger` criado (`lib/core/utils/app_logger.dart`)
- [x] `HttpsInterceptor` criado (`lib/core/utils/https_interceptor.dart`)
- [ ] Android Network Security Config — criar `android/app/src/main/res/xml/network_security_config.xml` e referenciar no `AndroidManifest.xml`
- [ ] iOS ATS — verificar/configurar `ios/Runner/Info.plist`

### Alto
- [ ] Escapar wildcards LIKE (`%`, `_`) antes do binding em `fallback_database_repository.dart:234`
- [ ] Validação de input na busca — limite máximo de caracteres em `search_viewmodel.dart:22`
- [ ] Rate limiting / debounce nas chamadas de busca (`search_viewmodel.dart`)
- [ ] Auditoria de dependências para CVEs (`pubspec.yaml` → `flutter pub outdated`)

### Médio
- [ ] Certificate pinning no Dio
- [ ] Obfuscação em release builds (`flutter build --obfuscate --split-debug-info`)
- [ ] Verificação de integridade do asset `ARC.db` (SHA-256 ao copiar)

---

## Testes

- [ ] Widget tests (`test/widget_test.dart` está todo comentado)
  - [ ] `HomePageWidget` — toggle de API, trigger de busca
  - [ ] `BookPageWidget` — grid de capítulos
  - [ ] `ChapterPageWidget` — lista de versículos
  - [ ] `SearchDelegateWidget` — resultados de busca
- [ ] `SearchVersesUseCase` test (ausente em `test/domain/usecases/`)
- [ ] `SearchViewModel` test (ausente em `test/presentation/viewmodels/`)
- [ ] `ConfigService` / `SharedPrefConfigService` tests
- [ ] Suite de testes de segurança (`test/security/`) — validação de input, escape LIKE, parâmetros de rota

---

## Features

- [ ] **Favoritos / marcadores** — salvar versículos localmente (SharedPreferences ou SQLite)
- [ ] **Histórico de busca** — persistir últimas pesquisas (SharedPreferences)
- [ ] **Copiar versículo** — ação de cópia com formatação (ex.: "Gn 1:1 — No princípio...")
- [ ] **Tema escuro / claro** — toggle dia/noite
- [ ] **Paginação** — listas grandes de versículos/livros
- [ ] **Planos de leitura** — planos temáticos ou anuais
- [ ] **Text-to-Speech** — leitura em voz alta
- [ ] **Compartilhamento** — compartilhar versículo como texto ou imagem
- [ ] **Filtros avançados de busca** — por livro, testamento, período
- [ ] **Autocomplete na busca**

---

## Performance

- [ ] Auditar widgets sem `const` que poderiam ter
- [ ] Verificar `FutureBuilder`/`StreamBuilder` com `initialData` para evitar flash de loading
- [ ] Adicionar `RepaintBoundary` em animações pesadas (se houver)
- [ ] Verificar se `DatabaseRetriever` está registrado como `Singleton` (não `Bind`) no `book_module.dart`

---

## Infra / CI

- [ ] Pipeline CI (GitHub Actions) — `flutter test` + `flutter analyze` em PRs
- [ ] Pre-commit hooks — detectar `print()` e URLs `http://` hardcoded
- [ ] `SECURITY.md` — política de reporte de vulnerabilidades
