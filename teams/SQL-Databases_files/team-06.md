# Team 06 — Módulo de Notas

## Integrantes
Celia Hiromi Watanabe
# Descrição do Módulo
Este módulo é responsável pela tabela de notas, registros de notas e consultas de notas.

# Scripts SQL

# CREATE TABLE: alunos e disciplinas
```sql
CREATE DATABASE IF NOT EXISTS sistema_escolar;
USE sistema_escolar;

CREATE TABLE alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome_aluno VARCHAR(100) NOT NULL
);

CREATE TABLE disciplinas (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL
);

```
# INSERT INTO: alunos e disciplinas

```sql

INSERT INTO alunos (nome_aluno) VALUES 
('Mariana Silva'),
('João Pedro Costa'),
('Ana Oliveira');

INSERT INTO disciplinas (nome_disciplina) VALUES 
('Banco de Dados Relacional'),
('Algoritmos e Lógica de Programação'),
('Engenharia de Software');


```
# CREATE TABLE notas

```sql
CREATE TABLE notas (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_disciplina INT NOT NULL,
    valor_nota DECIMAL(4,2) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_disciplina) REFERENCES disciplinas(id_disciplina)
);
```
# INSERT INTO: notas

```sql
INSERT INTO notas (id_aluno, id_disciplina, valor_nota) VALUES 
(1, 1, 9.50),
(1, 2, 8.00),
(2, 1, 7.50),
(3, 3, 10.00);

```

# CONSULTAS SQL 

```sql
SELECT * FROM notas;

SELECT id_aluno, valor_nota FROM notas WHERE valor_nota >= 8.00;

```

# JOIN

```sql
SELECT 
    a.nome_aluno AS Aluno, 
    d.nome_disciplina AS Disciplina, 
    n.valor_nota AS Nota
FROM notas n
JOIN alunos a ON n.id_aluno = a.id_aluno
JOIN disciplinas d ON n.id_disciplina = d.id_disciplina
ORDER BY n.valor_nota DESC;
```

# Screenshots

[CODIGO
](https://drive.google.com/file/d/1Z-9T4SCzs2sK-s8Rp1N-EXEXa7Jdw7ZZ/view?usp=sharing)

---
[TABELA
](https://drive.google.com/file/d/1lGgXNpXADB1tzQv2pYHzaUg6HWsCCel_/view?usp=sharing)

