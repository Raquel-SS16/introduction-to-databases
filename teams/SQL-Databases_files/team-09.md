# Team 09 — Módulo de Frequência

## Integrantes

- Markus Paulo Ramos Soares

---

# Descrição

O módulo de Frequência é responsável pelo controle de presença dos alunos nas disciplinas do sistema acadêmico.

Esse módulo permite:

- registrar presença e faltas;
- consultar frequência dos alunos;
- realizar consultas utilizando JOIN;
- organizar os dados de forma relacional utilizando chaves primárias e estrangeiras.


---

# CREATE DATABASE


CREATE DATABASE IF NOT EXISTS sistema_escolar;

USE sistema_escolar;

---

# CREATE TABLE

## Tabela Alunos

CREATE TABLE alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    curso VARCHAR(100)
);

---

## Tabela Disciplinas

CREATE TABLE disciplinas (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT
);

---

## Tabela Frequência

CREATE TABLE frequencia (
    id_frequencia INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_disciplina INT NOT NULL,
    data_aula DATE NOT NULL,
    status_presenca ENUM('Presente', 'Falta') NOT NULL,

    CONSTRAINT fk_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES alunos(id_aluno),

    CONSTRAINT fk_disciplina
        FOREIGN KEY (id_disciplina)
        REFERENCES disciplinas(id_disciplina)
);

---

# INSERT INTO

## INSERTS NA TABELA ALUNOS

INSERT INTO alunos (nome, email, curso)
VALUES
('Carlos Silva', 'carlos@email.com', 'Sistemas de Informação'),
('Ana Souza', 'ana@email.com', 'Ciência da Computação'),
('Marcos Lima', 'marcos@email.com', 'Engenharia de Software'),
('Juliana Alves', 'juliana@email.com', 'Análise e Desenvolvimento de Sistemas');

---

## INSERTS NA TABELA DISCIPLINAS

INSERT INTO disciplinas (nome_disciplina, carga_horaria)
VALUES
('Banco de Dados', 80),
('Programação Web', 60),
('Estrutura de Dados', 80);

---

## INSERTS NA TABELA FREQUENCIA

INSERT INTO frequencia
(id_aluno, id_disciplina, data_aula, status_presenca)
VALUES
(1, 1, '2026-05-20', 'Presente'),
(1, 1, '2026-05-21', 'Falta'),
(2, 1, '2026-05-20', 'Presente'),
(2, 2, '2026-05-22', 'Presente'),
(3, 3, '2026-05-20', 'Falta'),
(4, 1, '2026-05-23', 'Presente'),
(3, 2, '2026-05-24', 'Presente'),
(1, 3, '2026-05-25', 'Presente');

---

# CONSULTAS SQL

## SELECT *

SELECT * FROM alunos;

SELECT * FROM disciplinas;

SELECT * FROM frequencia;

---

## SELECT COM WHERE

SELECT
    a.nome AS aluno,
    d.nome_disciplina AS disciplina,
    f.data_aula
FROM frequencia f
JOIN alunos a
    ON f.id_aluno = a.id_aluno
JOIN disciplinas d
    ON f.id_disciplina = d.id_disciplina
WHERE f.status_presenca = 'Falta';

---

## SELECT COM ORDER BY

SELECT *
FROM frequencia
ORDER BY data_aula;

---

# JOIN

SELECT
    a.nome AS aluno,
    d.nome_disciplina AS disciplina,
    f.data_aula,
    f.status_presenca
FROM frequencia f
JOIN alunos a
    ON f.id_aluno = a.id_aluno
JOIN disciplinas d
    ON f.id_disciplina = d.id_disciplina;

---

# CONSULTA EXTRA — TOTAL DE PRESENÇAS

SELECT
    a.nome,
    COUNT(*) AS total_presencas
FROM frequencia f
JOIN alunos a
    ON f.id_aluno = a.id_aluno
WHERE f.status_presenca = 'Presente'
GROUP BY a.nome;

---

# CONSULTA EXTRA — TOTAL DE FALTAS

SELECT
    a.nome,
    COUNT(*) AS total_faltas
FROM frequencia f
JOIN alunos a
    ON f.id_aluno = a.id_aluno
WHERE f.status_presenca = 'Falta'
GROUP BY a.nome;

---

# CONSULTA EXTRA — FILTRAR ALUNO ESPECÍFICO

SELECT
    a.nome,
    d.nome_disciplina,
    f.data_aula,
    f.status_presenca
FROM frequencia f
JOIN alunos a
    ON f.id_aluno = a.id_aluno
JOIN disciplinas d
    ON f.id_disciplina = d.id_disciplina
WHERE a.nome = 'Carlos Silva';

---

# ALTER TABLE

ALTER TABLE frequencia
ADD justificativa VARCHAR(255);

---

# UPDATE

UPDATE frequencia
SET justificativa = 'Atestado médico'
WHERE id_frequencia = 2;

---

# CONSULTA FINAL COM JUSTIFICATIVA

SELECT
    a.nome AS aluno,
    d.nome_disciplina AS disciplina,
    f.data_aula,
    f.status_presenca,
    f.justificativa
FROM frequencia f
JOIN alunos a
    ON f.id_aluno = a.id_aluno
JOIN disciplinas d
    ON f.id_disciplina = d.id_disciplina;

---

# Screenshots

<img width="480" height="107" alt="Captura de tela 2026-05-27 093002" src="https://github.com/user-attachments/assets/4ffd7071-a829-4a6b-8e04-0b1117abd214" />
<img width="313" height="95" alt="Captura de tela 2026-05-27 093016" src="https://github.com/user-attachments/assets/72f03244-61b3-475c-9df4-2020cbd13e79" />
<img width="399" height="140" alt="Captura de tela 2026-05-27 093023" src="https://github.com/user-attachments/assets/f1664bed-c49e-4566-a66a-42b8f3683d36" />
<img width="291" height="55" alt="Captura de tela 2026-05-27 093031" src="https://github.com/user-attachments/assets/1e6fe6ac-33f3-4c25-ba71-183e1ad3387f" />
<img width="413" height="153" alt="Captura de tela 2026-05-27 093039" src="https://github.com/user-attachments/assets/1ca8bfda-0e5d-4bc6-b9e4-1d74d9e69c27" />
<img width="397" height="153" alt="Captura de tela 2026-05-27 093046" src="https://github.com/user-attachments/assets/513a2b60-3cd2-4244-bf52-449398c439a0" />
<img width="208" height="103" alt="Captura de tela 2026-05-27 093052" src="https://github.com/user-attachments/assets/a5b1c6cf-ab56-4e8a-a2b0-2b7d26b55727" />
<img width="184" height="72" alt="Captura de tela 2026-05-27 093057" src="https://github.com/user-attachments/assets/98864e44-c54f-4e04-b952-6463aa73a8b3" />
<img width="400" height="93" alt="Captura de tela 2026-05-27 093104" src="https://github.com/user-attachments/assets/883059ee-2590-432e-bf21-b6170363bb9d" />
<img width="487" height="159" alt="Captura de tela 2026-05-27 093112" src="https://github.com/user-attachments/assets/0059c010-fe60-4180-bf83-d78e6de8ef1e" />
