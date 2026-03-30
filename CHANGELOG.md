# Changelog

Todas as mudanças notáveis neste projeto são documentadas neste arquivo.
Formato baseado em [Keep a Changelog](https://keepachangelog.com).

---

## [2026-03-30]

### Changed
- **Docs reorganização**: TODO.md, NEXT-STEPS.md movidos para `docs/`
- TODO.md expandido: 74 linhas de tarefas (segurança, testes, features, perf)

---

## [2026-03-22] — Security Hardening

### Added
- `AppLogger` (logger v2.4.0): logging estruturado, silent em release
- `AppErrorHandler`: mensagens genéricas ao user, nunca expõe URLs/stack traces
- `HttpsInterceptor`: bloqueia HTTP em release (Dio)
- Android Network Security Config: cleartext bloqueado em produção

### Fixed
- Dio com timeouts (connect: 10s, receive: 15s, send: 10s)
- 18x `print()` → `appLogger` em data layer
- 4 ViewModels: não expõem mais detalhes de exceção na UI
- `int.tryParse()` em rotas — evita crash por deep link malformado

### Changed
- `avoid_print` habilitado no lint — zero prints em produção
- `analysis_options.yaml` atualizado

---

## [2026-03-21]

### Added
- Screenshot captura/seleção de versículos
- **CLAUDE.md**: arquitetura, padrões, testing, performance
- **TODO.md**: roadmap detalhado

### Fixed
- `withOpacity` → `.withValues` (obsoleto)
- Altura de linha versículos (StrutStyle)

### Changed
- UX seleção/cópia versículos
- Espaçamentos nas listagens
- Cobertura testes ReferenceParser

---

## [2026-01-04]

### Fixed
- Substituído método `withOpacity` (obsoleto) por `.withValues` compatível
- Corrigido erro na busca de intervalos de versículos (ex.: Gn 1:1-5)

### Changed
- Atualizações gerais de pacotes para versões estáveis
- Espaçamentos nas listagens de versículos otimizados para melhor visual

### Added
- Melhorias na seleção e cópia de versículos com melhor feedback visual

---

## [2025-12-10] — Busca e Testes

### Added
- Novos testes unitários abrangentes para melhorar cobertura
- Testes do `ReferenceParser` com casos de uso realistas
- Destaque visual de intervalo de versículos (ex.: Gn 1:1-5)
- Melhorias na integração com API remota

### Fixed
- Erro crítico na busca por API resolvido
- Chamadas para novo endpoint da API corrigidas
- Comportamento de fallback local/remoto estabilizado

### Changed
- Busca agora prioriza API quando online, fallback seguro para local quando offline
- Estrutura de testes refatorada para melhor manutenibilidade

---

## [2025-12-08] — Integração API

### Added
- Integração completa com API remota para busca e dados adicionais
- Novos testes unitários para validar comportamento online/offline
- Melhor tratamento de dependências em testes

### Fixed
- Testes corrigidos após integração com API
- Injeção de dependências estabilizada para environment de testes

### Changed
- Estrutura de repositórios otimizada para suportar fallback

---

## [2025-12-07]

### Added
- Destaque visual de versículos encontrados em buscas
- Feedback visual melhorado para resultados de busca

---

## [2025-12-02] — Busca Full-Text

### Added
- Busca por texto completo em versículos
- **SearchVersesUseCase**: novo caso de uso para busca centralizada
- Novas funcionalidades e ideias documentadas no TODO
- Primeira fase da implementação de busca avançada

### Changed
- Estrutura de busca refatorada para melhor performance
- Dependências corrigidas e consolidadas

---

## [2025-11-27] — Testes e Repositórios

### Added
- Novos tratamentos de erros robustos em toda a aplicação
- Suite de testes unitários para repositórios
- Testes específicos de `FallbackDatabaseRepository`

### Changed
- Injeção de dependência do `DatabaseRepository` melhorada
- Estrutura de repositórios otimizada com melhor separação de responsabilidades

---

## [2025-11-20]

### Fixed
- Inconsistências em documentação corrigidas (arquivos .md)

---

## [2025-11-03]

### Fixed
- Tamanho e posição dos capítulos na tela corrigidos

---

## [2025-11-01] — Clean Architecture & Refactoring

### Added
- **GEMINI.md** e **next-steps.md**: documentação de roadmap
- Refatoração completa para padrão **Clean Architecture**
- Suite de testes unitários com mockito
- Estilo visual melhorado no nome do livro (home page)
- Estrutura de testes bem definida (unit, widget, integration)

### Changed
- Atualizações de pacotes (major version upgrade)
- Estrutura de pastas alinhada com Clean Architecture (core/, domain/, data/, presentation/)
- Arquitetura de state management com ChangeNotifier + AnimatedBuilder

### Impact
- Projeto refatorado de monólito para arquitetura testável e escalável

---

## [2025-10-24]

### Added
- Print apenas em debug mode (remover logs da release)

### Changed
- TODO's e tarefas técnicas adicionadas

---

## [2025-10-22]

### Fixed
- Typo corrigido no código

---

## [2024-10-19] — Navegação Completa

### Added
- Navegação completa entre telas: books → chapters → verses
- Método `getChaptersByBook()` implementado
- Módulo de livros integrado com Modular

### Fixed
- Problema na listagem de versículos resolvido
- Navegação do Modular (pop/push) corrigida
- Imports não utilizados removidos

---

## [2024-10-18] — UI & Modular Setup

### Added
- **Books Page**: listagem de livros com FutureBuilder
- **Chapters Page**: grid de capítulos
- **Verses Page**: visualização de versículos
- Suporte web na conexão com banco de dados
- **Modular**: framework de injeção de dependência
- **ConfigService**: serviço centralizado de configuração
- Suporte desktop via `sqflite_common_ffi`

### Fixed
- Bug de banco de dados no Android resolvido
- Injeção de dependências estabilizada

### Changed
- Tamanho dos tiles do grid ajustados
- Cores dos tiles alteradas para melhor visual
- Método `databaseFactoryFfi` revertido para versão estável

---

## [2024-10-17] — Database Setup

### Added
- Arquivos de modelo (models) e conexão com banco de dados
- Arquivo de banco de fallback
- Configurações iniciais em main.dart
- Estrutura básica de pastas

### Changed
- Estrutura de pastas refatorada
- Pacotes atualizados para versão estável
- Cores principais do app ajustadas
- Métodos do controller tornados privados

### Fixed
- Código antigo removido
- Inferência de tipo String ao error

---

## [2024-10-16] — Initial Setup

### Added
- Projeto Flutter inicial
- .gitignore configurado
- Estrutura base do projeto
- Primeiro commit

---

## Resumo de Períodos

| Período | Foco | Status |
|---------|------|--------|
| **Out 2024** | Setup base, UI, Modular | ✅ Estável |
| **Out 2025** | Clean Architecture, Testes | ✅ Refatorado |
| **Nov-Dez 2025** | Busca, API remota, Testes | ✅ Integrado |
| **Jan-Mar 2026** | Melhorias, Documentação | ✅ Documentado |

---

## Notas Técnicas

- **Período de desenvolvimento**: Outubro 2024 — Março 2026
- **Arquitetura**: Clean Architecture com MVVM
- **State Management**: ChangeNotifier + AnimatedBuilder
- **Banco de dados**: SQLite local (ARC.db) com fallback para API remota
- **Dependency Injection**: flutter_modular
- **Testes**: mockito com build_runner
- **Principais features**:
  - ✅ Navegação (books → chapters → verses)
  - ✅ Busca (referências bíblicas + full-text)
  - ✅ Toggle API/offline
  - ✅ Seleção e cópia de versículos
  - ✅ Suporte desktop (web, desktop)

Para detalhes técnicos completos, veja [CLAUDE.md](CLAUDE.md) | [TODO.md](TODO.md)
