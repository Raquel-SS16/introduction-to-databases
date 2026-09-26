# SPRINT 2/5 — Subconsultas e Consultas Avançadas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# Objetivo da Sprint 2/5

Nesta etapa, cada aluno deverá aprofundar as consultas SQL por meio de **subconsultas**.

O objetivo é resolver perguntas em que uma consulta depende do resultado produzido por outra consulta.

Serão trabalhados:

```sql
SUBQUERY
IN
NOT IN
EXISTS
NOT EXISTS
AVG
MAX
MIN
COUNT
subconsulta correlacionada
```

O aluno deverá continuar utilizando o mesmo banco do `Module-1`.

---

# 1. Identificação

**Nome completo:**

> Raquel Silva dos Santos

**Banco utilizado:**

```text
series_watchlist_db

```

---

# 2. O que é uma subconsulta?

Uma subconsulta é um `SELECT` utilizado dentro de outro comando SQL.

Exemplo:

```sql
SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);
```

Neste exemplo:

1. a consulta interna calcula a média;
2. a consulta externa utiliza esse resultado.

---

# 3. Perguntas que exigem subconsulta

Defina pelo menos cinco perguntas do seu domínio que possam ser resolvidas com subconsultas.

1. Quais séries obtiveram nota média superior à média geral de todas as avaliações registadas na base de dados?
2. Quais utilizadores têm pelo menos uma série adicionada à sua watchlist?
3. Quais plataformas de streaming cadastradas não possuem qualquer série vinculada no catálogo?
4. Quais são as séries mais antigas do catálogo (lançadas no menor ano registado)?
5. Para cada utilizador, quais são as séries cuja nota atribuída foi estritamente superior à sua própria média pessoal de avaliações?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais são as séries cuja avaliação individual na watchlist foi superior à média aritmética de todas as notas registadas na plataforma?

SQL

```sql
-- SELECT 
    id_serie, 
    id_usuario, 
    nota, 
    comentario
FROM item_watchlist
WHERE nota > (
    SELECT AVG(nota)
    FROM item_watchlist
    WHERE nota IS NOT NULL
);
```

**Explique primeiro a consulta interna:**

> A subconsulta (SELECT AVG(nota) FROM item_watchlist WHERE nota IS NOT NULL) é executada e calcula a média geral de todas as notas válidas do sistema, retornando um único valor escalar (por exemplo, 9.21).

**Depois explique a consulta externa:**

> A consulta externa examina linha a linha da tabela item_watchlist e seleciona apenas os registos cujo valor na coluna nota é estritamente maior do que o valor escalar retornado pela consulta interna.

---

# 5. Subconsulta com IN

Exemplo:

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedido
);
```

## Consulta obrigatória

**Pergunta:**

> Quais utilizadores possuem pelo menos uma série registada na sua lista de acompanhamento (item_watchlist)?

```sql
-- SELECT 
    id_usuario, 
    nome, 
    email
FROM usuario
WHERE id_usuario IN (
    SELECT DISTINCT id_usuario
    FROM item_watchlist
);
```

**Explique:**

> A subconsulta gera uma lista vertical com todos os identificadores de utilizadores (id_usuario) presentes na tabela associativa item_watchlist. O operador IN compara o identificador da tabela usuario com esse conjunto, trazendo apenas os utilizadores ativos que já adicionaram itens.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais plataformas de streaming registadas no sistema não possuem nenhuma série associada no catálogo?

SQL

```sql
-- SELECT 
    id_plataforma, 
    nome_plataforma
FROM plataforma
WHERE id_plataforma NOT IN (
    SELECT DISTINCT id_plataforma
    FROM serie
    WHERE id_plataforma IS NOT NULL
);
```

**Que registros você está procurando?**

> Estamos à procura das plataformas que estão ociosas no catálogo (como a Paramount+, cujo ID não se encontra na tabela serie). O filtro explícito WHERE id_plataforma IS NOT NULL na subconsulta é uma boa prática para evitar que valores nulos invalidem a lógica booleana do NOT IN.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais utilizadores atribuíram nota máxima (10.0) a pelo menos uma série?

```sql
-- SELECT 
    u.id_usuario, 
    u.nome
FROM usuario AS u
WHERE EXISTS (
    SELECT 1
    FROM item_watchlist AS w
    WHERE w.id_usuario = u.id_usuario
      AND w.nota = 10.0
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique a diferença em relação a `EXISTS`:**

> Escreva aqui.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique:**

> Escreva aqui.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> Escreva aqui.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Escreva aqui.

### JOIN

```sql
-- Cole aqui.
```

### SUBQUERY

```sql
-- Cole aqui.
```

### Qual abordagem ficou mais compreensível?

> Escreva aqui e justifique.

---

## Pergunta 2

> Escreva aqui.

### JOIN

```sql
-- Cole aqui.
```

### SUBQUERY

```sql
-- Cole aqui.
```

### Comparação

> Escreva aqui.

---

# 12. Quantidade mínima exigida

O `SPRINT2-5.sql` deverá conter no mínimo:

```text
1 subconsulta com comparação
1 subconsulta com IN
1 subconsulta com NOT IN
1 consulta com EXISTS
1 consulta com NOT EXISTS
1 subconsulta com MAX ou MIN
1 subconsulta correlacionada
2 problemas resolvidos com JOIN e SUBQUERY
```

---

# 13. Validação prática

Escolha uma subconsulta.

```sql
-- Cole aqui.
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> Escreva aqui.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
-- Cole aqui.
```

**Alteração realizada:**

> Escreva aqui.

**Mudança observada:**

> Escreva aqui.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 16. Estrutura recomendada do SPRINT2-5.sql

```sql
-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- SUBQUERY COM COMPARAÇÃO

-- IN

-- NOT IN

-- EXISTS

-- NOT EXISTS

-- MAX / MIN

-- SUBQUERY CORRELACIONADA

-- PROBLEMA 1 - JOIN

-- PROBLEMA 1 - SUBQUERY

-- PROBLEMA 2 - JOIN

-- PROBLEMA 2 - SUBQUERY
```

---

# 17. Checklist

- [ ] utilizei o banco do projeto;
- [ ] criei subconsulta com comparação;
- [ ] utilizei `IN`;
- [ ] utilizei `NOT IN`;
- [ ] utilizei `EXISTS`;
- [ ] utilizei `NOT EXISTS`;
- [ ] utilizei `MAX` ou `MIN`;
- [ ] criei subconsulta correlacionada;
- [ ] resolvi duas perguntas usando JOIN e SUBQUERY;
- [ ] expliquei o raciocínio;
- [ ] testei no MySQL Workbench;
- [ ] consigo explicar as consultas presencialmente;
- [ ] salvei `SPRINT2-5.md`;
- [ ] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Continue na mesma branch:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT2-5.md
Module-2/SPRINT2-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 2 de 5 - subconsultas
```

**Não abra o Pull Request final.**

---

# Próxima etapa

Na Sprint 3/5 serão trabalhadas:

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT em VIEW
DROP VIEW
```
