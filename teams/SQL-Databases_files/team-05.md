# Team 05 — Nome do Módulo

## Integrantes

- Nome: Leslie Bruna Pires dos Santos

---

# Descrição

Este módulo gerencia o vinculo academico atuando como uma tabela associativa, de muitos para muitos entre a tabela aluno e disciplina.

---

# CREATE TABLE

```sql
CREATE TABLE matriculas (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_disciplina INT,
    data_matricula DATE NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_disciplina) REFERENCES disciplinas(id_disciplina)
);
```
---

# INSERT INTO

```sql
INSERT INTO matriculas (id_aluno, id_disciplina, data_matricula) VALUES
(1, 1, '2024-07-01'),
(1, 2, '2024-07-15'),
(2, 1, '2024-07-01'),
(3, 3, '2024-07-29');
```

---

# CONSULTAS SQL

## SELECT *

```sql
SELECT * FROM alunos;
```

---

## SELECT COM WHERE

```sql
SELECT * FROM disciplinas WHERE carga_horaria > 60;
```

---

## SELECT COM ORDER BY

```sql
SELECT * FROM cursos ORDER BY nome_curso;

```

---

# JOIN

```sql
SELECT a.nome_aluno, c.nome_curso 
FROM alunos a
JOIN cursos c ON a.id_curso = c.id_curso;
```

---

# Screenshots
<img width="1600" height="807" alt="image" src="https://github.com/user-attachments/assets/36df3884-a2a0-48b8-98bb-61cbaadb4e32" />



Inser]ir screenshots do MySQL Workbench abaixo.
