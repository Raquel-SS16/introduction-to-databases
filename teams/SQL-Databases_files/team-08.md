# Team 08 — Módulo de Departamentos

## Integrantes

- Mariano Lino da Silva Neto
---

# Descrição

Responsável por:

    tabela de departamentos
    registros de departamentos
    consultas de departamentos
---
# CREATE TABLE
CREATE DATABASE IF NOT EXISTS SIGAA;
USE SIGAA;

CREATE TABLE departamentos (
  id_departamento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  sigla VARCHAR(10) NOT NULL,
  campus VARCHAR(50) NOT NULL
  );
# INSERT INTO
  INSERT INTO departamentos (nome, sigla, campus) VALUES
  ('Computação', 'COMP', 'Rondonopolis'),
  ('Matematica', 'MAT', 'Rondonopolis'),
  ('Fisica', 'FIS', 'Cuiaba');

  CREATE TABLE cursos (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  nome_curso VARCHAR(100) NOT NULL,
  id_departamento INT
  );

  INSERT INTO cursos (nome_curso, id_departamento) VALUES
  ('Sistemas de Informação', 1),
  ('Ciencia da Computação', 1),
  ('Licenciatura em Matemática', 2);
# CONSULTAS SQL
  SELECT * FROM departamentos;
## SELECT COM WHERE
  SELECT nome, campus FROM departamentos WHERE sigla = 'COMP';

  SELECT sigla, nome, campus FROM departamentos ORDER BY nome ASC;
## SELECT COM ORDER BY
  SELECT d.sigla AS Departamento, d.nome, c.nome_curso AS Curso
  FROM departamentos d
  # JOIN
  JOIN cursos c ON d.id_departamento = c.id_departamento;
---

# Screenshots
<img width="1920" height="1013" alt="Breno" src="https://github.com/user-attachments/assets/dc2e8dd7-3a42-4e42-89cf-1a2bbb796f17" />
<img width="1920" height="874" alt="Captura de tela de 2026-05-22 00-48-42" src="https://github.com/user-attachments/assets/6cb25b3c-424c-4d15-95e7-69cd34c7052f" />
<img width="1920" height="1013" alt="Captura de tela de 2026-05-22 00-48-45" src="https://github.com/user-attachments/assets/85f5ace7-f9f0-4a51-a905-1818cd7e24bd" />
<img width="1920" height="1009" alt="Captura de tela de 2026-05-22 00-48-48" src="https://github.com/user-attachments/assets/e39682c7-7f98-4ba4-9ee8-e21dc75cd7ff" />




