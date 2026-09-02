# Team 16 — Integração Final 

## Integrantes

- Aluno Teste

---

# Descrição

Este módulo é responsável pela integração final do projeto de banco de dados.

---

# CREATE TABLE

```sql
CREATE TABLE integration_test (
    id INT PRIMARY KEY,
    description VARCHAR(100)
);
```

---

# INSERT INTO

```sql
INSERT INTO integration_test VALUES (1, 'Teste de integração');
```

---

# CONSULTAS SQL

## SELECT *

```sql
SELECT * FROM integration_test;
```

## SELECT COM WHERE

```sql
SELECT * FROM integration_test
WHERE id = 1;
```

## SELECT COM ORDER BY

```sql
SELECT * FROM integration_test
ORDER BY description;
```

---

# JOIN

```sql
SELECT *
FROM integration_test;
```

---

# Screenshots

Teste rápido de Pull Request.
