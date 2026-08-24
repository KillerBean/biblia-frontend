# Adequação arquitetural

Projeto: `biblia_front`
Owner: equipe do produto Bíblia
Perfil: A — apresentação
Nível atual: L1
Nível alvo: L2
Data da avaliação: 2026-08-24

## Controles

- [x] Status e arquitetura documentados
- [x] Runtime e dependências fixados no `pubspec.lock`/`pubspec.yaml`
- [x] CI obrigatório em PR
- [x] Testes e análise estática exigidos pelo nível
- [x] Secret/dependency scan básico
- [x] Asset SQLite com origem, licença, tamanho e checksum
- [x] Assinatura release sem fallback silencioso para debug
- [ ] Acessibilidade e widget tests de jornadas críticas
- [ ] Deploy/rollback de artefatos de loja

## Exceções/ADRs

| Regra | ADR | Owner | Expira em |
|---|---|---|---|
| O CI valida Android; iOS/web dependem de toolchains ainda não presentes | ADR pendente | equipe Bíblia | antes do suporte oficial dessas plataformas |
| Pin de certificado não implementado; HTTPS e Network Security Config são o controle atual | ADR pendente | equipe Bíblia | revisar na próxima auditoria |

## Próximas três ações

1. Adicionar widget tests das jornadas de leitura e busca.
2. Configurar secrets do keystore no ambiente de release e exercitar build assinado.
3. Definir suporte oficial para iOS/web e adicionar suas matrizes de CI.
