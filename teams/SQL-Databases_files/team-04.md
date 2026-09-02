# Team 04 — Módulo de Disciplinas

## Integrantes

- Talita de Oliveira Leite

---

# Descrição

Este módulo apresenta a criação de banco de dados relacional (MySQL) para o gerenciamento do módulo de Disciplinas.

---

# CREATE TABLE

```sql
CREATE TABLE disciplinas (
    id_disciplina INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    carga_horaria INT,
    id_curso INT,
    id_professor INT,
    PRIMARY KEY (id_disciplina),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    FOREIGN KEY (id_professor) REFERENCES professores(id_professor)
);
```

---

# INSERT INTO

```sql
INSERT INTO disciplinas (nome, codigo, carga_horaria, id_curso, id_professor) VALUES
('Introducao a Banco de Dados', 'BAN001', 60, 1, 1),
('Algoritmos e Logica de Programacao', 'ALG001', 80, 1, 2),
('Estruturas de Dados', 'EST001', 60, 1, 3),
('Engenharia de Software', 'ENG001', 60, 2, 1),
('Redes de Computadores', 'RED001', 60, 2, 2),
('Inteligencia Artificial', 'INT001', 80, 2, 3),
('Calculo I', 'CAL001', 80, 3, 4),
('Fisica Aplicada', 'FIS001', 60, 3, 4);
```

---

# CONSULTAS SQL

-- para ver a tabela completa:

```sql
SELECT
    d.id_disciplina AS ID,
    d.nome AS `Nome da Disciplina`,
    d.carga_horaria AS `Carga Horaria`,
    c.nome AS Curso,
    p.nome AS Professor
FROM disciplinas d
INNER JOIN cursos c ON d.id_curso = c.id_curso
INNER JOIN professores p ON d.id_professor = p.id_professor;
```

---

## SELECT COM WHERE

```sql
SELECT id_disciplina, nome, carga_horaria
FROM disciplinas
WHERE carga_horaria > 60;
```

## SELECT COM ORDER BY

```sql
SELECT id_disciplina, nome, carga_horaria
FROM disciplinas
ORDER BY nome ASC;
```

---

# JOIN

```sql
SELECT
    d.id_disciplina AS ID,
    d.nome AS `Nome da Disciplina`,
    d.carga_horaria AS `Carga Horaria`,
    c.nome AS Curso,
    p.nome AS Professor
FROM disciplinas d
INNER JOIN cursos c ON d.id_curso = c.id_curso
INNER JOIN professores p ON d.id_professor = p.id_professor;
```

---
