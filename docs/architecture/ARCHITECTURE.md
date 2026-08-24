# Arquitetura — Biblia Front

## Classificação

- **Status:** produto ativo
- **Owner:** equipe do produto Bíblia
- **Perfil:** A — apresentação
- **Nível atual/alvo:** L2
- **Plataformas verificadas:** Android e Linux; web/iOS dependem de adapters e toolchains próprios

## Fronteiras

```text
Presentation (MVVM) → Domain (use cases/contracts) → Data (API Dio / SQLite)
```

O app é offline-first: o repositório tenta a API somente quando habilitado e
faz fallback para o SQLite local. Views não acessam Dio ou SQLite diretamente.
O banco local é um asset versionado e sua cópia é validada por SHA-256.

## Gates L2

O CI executa `flutter analyze --fatal-infos`, testes com cobertura, integridade
do asset, auditoria de dependências e build Android debug. Builds release
exigem keystore configurado e são rejeitados quando tentam usar assinatura de
debug sem opt-in local explícito.

## Configuração

`API_BASE_URL` é obrigatório para habilitar a API e deve ser uma URL HTTPS em
builds de produção. Não existe fallback HTTP para localhost no código.
