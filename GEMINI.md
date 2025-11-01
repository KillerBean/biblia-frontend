# GEMINI.md

> Guia de integração do Gemini CLI e convenções do projeto — *App Bíblia Flutter* (MVVM)

---

## Visão geral

Este documento descreve como usar o Gemini CLI para padronizar a arquitetura, convenções e automações do projeto **App Bíblia** escrito em Flutter. O projeto consome uma API remota e também mantém uma cópia local dos dados em SQLite para uso offline. O objetivo é garantir que o código existente seja migrado/organizado segundo o padrão **MVVM** (Model-View-ViewModel), com boas práticas de teste, modularidade e manutenibilidade.

### Público-alvo

* Desenvolvedores que irão modificar ou refatorar o código existente
* Revisores de PRs
* DevOps que precisam conhecer scripts/CI

---

## Objetivos do Gemini CLI

1. Gerar scaffolding (estruturas de pasta, arquivos base, ViewModels, Repositories e Providers).
2. Aplicar templates padronizados para MVVM.
3. Adicionar/atualizar integrações com SQLite (DAO/migrations) e com a API (clients e modelos).
4. Inserir hooks/linters e gerar testes unitários básicos.
5. Automatizar migração de código espalhado para módulos coerentes com MVVM.

> Observação: o CLI não reescreverá lógica de negócio complexa automaticamente — ele provê *scaffolding* e refactors seguros para acelerar a migração.

---

## Estrutura de pastas recomendada (exemplo)

```
/lib
  /core
    /exceptions
    /network
    /utils
    /di              # Configuração de Injeção de dependência: usar **flutter_modular** para organizar módulos e rotas.
  /data
    /datasources
      api_client.dart
      local_sqlite.dart
    /models
    /repositories
    /mappers
    /local/          # código relacionado ao sqlite (DAOs, migrations)
  /domain
    /entities
    /usecases
  /presentation
    /views
      home_view.dart
      bible_view.dart
    /viewmodels
      home_viewmodel.dart
      bible_viewmodel.dart
    /widgets
  /shared            # temas, estilos, strings

/assets
/test
/tools               # scripts, helpers do Gemini CLI

pubspec.yaml

```

---

## Padrões e convenções

* **MVVM**: Views (Widgets/Pages) devem ser "esmagadas" — sem lógica de negócio. ViewModels ficam responsáveis por orquestrar os UseCases/Repositories e expor estados reativos.
* **Repository Pattern**: camada `data/repositories` implementa contratos definidos em `domain`.
* **Datasource**: separar `RemoteDataSource` (API) e `LocalDataSource` (SQLite). ViewModels usam UseCases, UseCases usam Repositories.
* **State management**: recomendado utilizar **Provider** (ou Provider, conforme preferência do time). Se o projeto já usa outro gerenciador, adote uma estratégia gradual.
* **Injeção de dependência**: usar `flutter_modular` + código gerado via `injectable` ou `provider` providers.
* **Nomes**: arquivo `xxx_view.dart`, `xxx_viewmodel.dart`, `xxx_repository.dart`, `xxx_dao.dart`.
* **Erros**: mapear exceções para `Failure`/`Result` quando exposto às camadas superiores.

---

## Integração com SQLite

* Local data source arquitetado em:

  * `data/local/database.dart` — inicializador da DB e migrations
  * `data/local/daos/*.dart` — operações CRUD por entidade (ex: `book_dao.dart`, `chapter_dao.dart`)
  * `data/models` — modelos que mapeiam para tabelas (com `toMap()` / `fromMap()`)

### Migrations

* Migrations versionadas numericamente. O Gemini CLI gera um novo arquivo de migration ao detectar alteração de schema.
* Exemplo de inicialização:

```dart
final db = await openDatabase(path, version: CURRENT_DB_VERSION, onCreate: (db, v) async {
  await db.execute(BookDao.createTableSql);
  await db.execute(ChapterDao.createTableSql);
});
```

---

## Consumo de API

* `core/network/api_client.dart` — HTTP client configurado (timeout, interceptors, logger).
* `data/datasources/remote/` — endpoints e mapeamento bruto para `data/models`.
* Usar DTOs (Data Transfer Objects) em `data/models` e convertê-los para `domain/entities` via `mappers`.

---

## Fluxo MVVM (exemplo: abrir um capítulo)

1. View inicia `BibleViewModel.loadChapter(bookId, chapterNumber)`.
2. ViewModel chama `LoadChapterUseCase.execute()`.
3. UseCase consulta `BibleRepository.getChapter()`.
4. Repository tenta `localDataSource.getChapter()`; se não existe ou stale, chama `remoteDataSource.fetchChapter()` e persiste localmente via DAO.
5. ViewModel atualiza estado reativo (por exemplo `AsyncValue` no Provider) e a View reconstrói.

---

## Regras e estratégias do Gemini CLI

1. `gemini generate view <Name>` — cria `views/<name>_view.dart`, `viewmodels/<name>_viewmodel.dart`, e adiciona provider skeleton.
2. `gemini generate repository <name>` — cria contrato (interface), implementação, e registra no DI.
3. `gemini generate dao <entity>` — cria DAO com CRUD básico e SQL de criação de tabela.
4. `gemini migrate-schema` — detecta modelos `data/models/*.dart` e gera arquivo de migration incremental.
5. `gemini analyze` — executa `dart analyze`, `flutter test` e formata código.
6. `gemini apply-style` — configura `analysis_options.yaml`, `.editorconfig` e `dart format`.

> O CLI tentará aplicar mudanças com commits automáticos (modo `--dry-run` disponível).

---

## Como o Gemini CLI ajuda na migração do código existente

* **Scanner de código**: identifica arquivos com lógica de UI acoplada e sugere extração para ViewModel.
* **Refactor templates**: move funções utilitárias para `core/utils` e adapta imports.
* **Detecção de persistência**: localiza uso de `sqflite` e propõe DAOs gerados que preservam a lógica.
* **Relatórios de mudança**: gera um `migration-report.md` com ações realizadas e trechos alterados.

---

## Exemplos de ViewModel simples

```dart
class BibleViewModel extends StateNotifier<AsyncValue<Chapter>> {
  final LoadChapterUseCase _loadChapter;

  BibleViewModel(this._loadChapter): super(const AsyncValue.loading());

  Future<void> loadChapter(String bookId, int number) async {
    state = const AsyncValue.loading();
    final result = await _loadChapter.execute(bookId, number);
    result.fold(
      (failure) => state = AsyncValue.error(failure),
      (chapter) => state = AsyncValue.data(chapter),
    );
  }
}
```

---

## Testes

* **Unit tests**: ViewModels e UseCases devem ter cobertura mínima.
* **Integration tests**: testar fluxo completo com banco em memória (in-memory sqlite) e mock de API.
* **Fixtures**: armazenar JSON de resposta da API em `/test/fixtures`.

---

## CI / CD

* Job `lint-and-test` executa `dart analyze --fatal-infos`, `dart format --output=none --set-exit-if-changed .`, `flutter test`.
* Opcional: job para rodar `gemini analyze` para checar conformidade com padrões MVVM configurados.

---

## Boas práticas de commits

* Prefixos: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`.
* PRs pequenos: migrar uma feature/camada por PR quando possível.

---

## Checklist de revisão (PR)

* [ ] Estrutura de pastas segue padrão.
* [ ] View contém apenas apresentação.
* [ ] ViewModel contém lógica/estado e é testado.
* [ ] Repositórios e DAOs têm contratos claros.
* [ ] Migrations adicionadas/corretas.
* [ ] Nenhum segredo (API keys) em código-fonte.

---

## Passo a passo rápido para começar com Gemini CLI

1. Instale/atualize o CLI: `pub global activate gemini_cli` (ou seguir instruções do time).
2. Rode um dry-run: `gemini generate view bible --dry-run`.
3. Gere um DAO para a entidade Book: `gemini generate dao book`.
4. Execute `gemini migrate-schema` para aplicar mudanças de banco.
5. Teste a aplicação localmente e abra PR com as alterações automáticas.

---

## Observações finais

* Este documento é um ponto de partida. Ajustes podem ser necessários conforme o código atual e escolhas de bibliotecas.
* Gemini CLI acelera a padronização, mas sempre revise automaticamente-gerado. O time mantém responsabilidade final pelas decisões arquiteturais.

---

*Gerado para o time do App Bíblia — siga as convenções e adapte conforme necessário.*
