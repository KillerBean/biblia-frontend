# Changelog

Todas as mudanças notáveis neste projeto são documentadas neste arquivo.

## [2026-03-21]

### Added
- Screenshot do feature de captura de versículos
- Documentação completa: CLAUDE.md com arquitetura e padrões
- TODO.md com roadmap detalhado de features e tarefas
- CHANGELOG.md com histórico completo

### Fixed
- Aviso de método obsoleto (`withOpacity` → `.withValues`)
- Altura de linha dos versículos ajustada com `StrutStyle`

### Changed
- Melhoria na seleção e cópia de versículos com melhor UX
- Espaçamentos ajustados nas listagens de versículos
- Testes do `ReferenceParser` expandidos

## [2026-01-04]

### Fixed
- Substituído `withOpacity` (obsoleto) por alternativa segura
- Corrigido erro na busca por intervalos de versículos

### Changed
- Atualizações de pacotes
- Espaçamentos nas listagens de versículos ajustados

### Added
- Melhoria na seleção e cópia de versículos

## [2025-12-10]

### Added
- Novos testes para melhorar cobertura de testes
- Testes do `ReferenceParser` com casos de uso reais
- Destaque de intervalo de versículos (ex.: Gn 1:1-5)

### Fixed
- Erro na busca por API resolvido
- Chamadas corrigidas para novo endpoint da API

### Changed
- Busca agora usa API quando online, fallback para local quando offline

## [2025-12-08]

### Added
- Integração com API remota para busca e dados
- Novos testes unitários

### Fixed
- Testes corrigidos após integração com API
- Tratamento de dependências melhorado

## [2025-12-07]

### Added
- Destaque visual de versículos encontrados na busca

## [2025-12-02]

### Added
- Busca por texto completo em versículos
- Use cases para busca de versículos (`SearchVersesUseCase`)
- Novas ideias e funcionalidades no TODO

### Changed
- Estrutura de busca refatorada
- Correções em dependências

## [2025-11-27]

### Added
- Novos tratamentos de erros em todo o app
- Novos testes unitários para repositórios
- Testes de `FallbackDatabaseRepository`

### Changed
- Injeção de dependência do `DatabaseRepository` melhorada
- Estrutura de repositórios otimizada

## [2025-11-20]

### Fixed
- Inconsistências nos arquivos de documentação corrigidas

## [2025-11-03]

### Fixed
- Tamanho e posição dos capítulos na tela corrigidos

## [2025-11-01]

### Added
- Documentação inicial: GEMINI.md e next-steps.md
- Refatoração completa para padrão Clean Architecture
- Testes unitários e estrutura de testes
- Estilo melhorado no nome do livro na página inicial

### Changed
- Atualizações de pacotes (major version)
- Estrutura de pastas alinhada com Clean Architecture

## [2025-10-24]

### Added
- Print apenas em debug mode

### Changed
- TODO's adicionados

## [2025-10-22]

### Fixed
- Typo corrigido

## [2024-10-19]

### Added
- Navegação entre páginas (books → chapters → verses)
- Correção de links e navegação do Modular

### Fixed
- Problema na listagem de versículos resolvido
- Modular pop e push corrigidos

## [2024-10-18]

### Added
- Page de listagem de livros com FutureBuilder
- Página de listagem de capítulos (chapters page)
- Page de visualização de versículos (verses page)
- Suporte web na conexão com banco de dados
- Modular para dependency injection
- Service de configuração (ConfigService)
- Página para listagem de livros

### Fixed
- Bug de banco de dados no Android corrigido
- Injeção de dependências resolvida

### Changed
- Adicionar `sqflite_common_ffi` para suporte desktop
- Tamanho dos tiles do grid ajustados
- Cores dos tiles alteradas
- Método `databaseFactoryFfi` revertido

## [2024-10-17]

### Added
- Arquivos de modelo e conexão com banco de dados
- Arquivo de banco de fallback
- Configurações em main.dart

### Changed
- Estrutura de pastas refatorada
- Pacotes atualizados
- Cores principais do app ajustadas
- Métodos do controller tornados privados

### Fixed
- Código antigo removido
- Pequenas correções gerais
- Inferência de tipo String ao error

## [2024-10-16]

### Added
- Projeto Flutter inicial
- .gitignore
- Estrutura base do projeto

---

## Notas

- **Período de desenvolvimento**: Outubro 2024 — Março 2026
- **Arquitetura**: Clean Architecture com MVVM
- **Banco de dados**: SQLite local (ARC.db) com fallback para API remota
- **Principais features**: Navegação, busca, seleção/cópia de versículos
- Para mais detalhes técnicos, veja [CLAUDE.md](CLAUDE.md)
