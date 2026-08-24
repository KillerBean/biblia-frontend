# Dados offline

`assets/db/ARC.db` é um asset de produto, não um fixture de teste. Ele contém
a tradução ARC e deve ser atualizado somente com a origem, versão, permissão
de distribuição e checksum registrados no pull request.

| Arquivo | Versão | Permissão | Tamanho | SHA-256 |
|---|---:|---|---:|---|
| `assets/db/ARC.db` | 1 | SBB | 4.575.232 bytes | `e8efc828da248d896edd2b1d624aa620f370d6948766026bb4b25fcfcdc5c0c2` |

O CI executa `tool/verify_assets.sh` e o runtime valida o SHA-256 antes de
copiar o banco do bundle para o armazenamento local. Alterações no banco
exigem atualização da constante em `DatabaseRetriever` e desta documentação.
