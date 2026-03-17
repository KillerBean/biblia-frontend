# TODO — Biblia Front

> Gerado em 2026-03-17. Marque com `[x]` quando concluído.

---

## Testes

- [ ] Implementar widget tests (`test/widget_test.dart` está todo comentado)
  - [ ] `HomePageWidget` — toggle de API, trigger de busca
  - [ ] `BookPageWidget` — grid de capítulos
  - [ ] `ChapterPageWidget` — lista de versículos
  - [ ] `SearchDelegateWidget` — resultados de busca
- [ ] Criar teste para `SearchViewModel` (ausente em `test/presentation/viewmodels/`)
- [ ] Testar `ConfigService` / `SharedPrefConfigService`

---

## Features ausentes

- [ ] **Marcadores / favoritos** — salvar versículos favoritos localmente
- [ ] **Histórico de busca** — persistir últimas pesquisas (SharedPreferences)
- [ ] **Tema escuro / claro** — toggle de tema (dia/noite)
- [ ] **Paginação** — para listas grandes de versículos/livros
- [ ] **Copiar versículo** — ação de cópia com formatação (ex.: "Gn 1:1 - No princípio...")

---

## Performance (conforme CLAUDE.md)

- [ ] Auditar widgets sem `const` que poderiam ter
- [ ] Verificar se `DatabaseRetriever` está registrado como `Singleton` (não `Bind`) no `book_module.dart`
- [ ] Adicionar `RepaintBoundary` em animações pesadas (se houver)
- [ ] Verificar `FutureBuilder`/`StreamBuilder` com `initialData` para evitar flash de loading

---

## Qualidade / arquitetura

- [ ] Adicionar `SearchVersesUseCase` nos testes de domínio (não há `search_verses_usecase_test.dart`)
- [ ] Habilitar/restaurar testes de integração (atualmente sem integração)
- [ ] Rever tratamento de erros na UI — apenas snackbars básicos

---

## Infra / CI

- [ ] Configurar pipeline CI (GitHub Actions ou similar) para rodar `flutter test` + `flutter analyze`
