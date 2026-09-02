# Team 10 — Módulo da Biblioteca

## Integrantes

- Raquel Silva Dos Santos

# Descrição

Este módulo apresenta a criação do banco de dados relacional (MySQL) para o gerenciamento do módulo da biblioteca.

# CREATE TABLE

```sql
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    PRIMARY KEY (id_autor)
);


CREATE TABLE livros (
    id_livro INT AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    ano_publicacao INT,
    id_autor INT,
    PRIMARY KEY (id_livro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);
```

---

# INSERT INTO

```sql
INSERT INTO autores (nome, nacionalidade) VALUES 
('Cida Bento', 'Brasileira'),
('Fiodor Dostoievski', 'Russo'),
('Franz Kafka', 'Austro-Húngaro'),
('Hanya Yanagihara', 'Norte-Americana');

INSERT INTO livros (titulo, ano_publicacao, id_autor) VALUES 
('O Pacto da Branquitude', 2022, 1),
('Noites Brancas', 2009, 2),
('A Metamorfose', 1997, 3),
('Uma Vida Pequena', 2016, 4);


---

# CONSULTAS SQL
-- para ver as tabelas separadamente:

SELECT * FROM autores;

SELECT * FROM livros;


--Para ver a tabela completa:
SELECT 
    l.id_livro AS ID,
    l.titulo AS `Título do Livro`, 
    l.ano_publicacao AS `Ano`, 
    a.nome AS Autor,
    a.nacionalidade AS Nacionalidade
FROM livros l
INNER JOIN autores a ON l.id_autor = a.id_autor;



```

---

## SELECT COM WHERE

```sql
SELECT id_livro, titulo, ano_publicacao 
FROM livros 
WHERE ano_publicacao > 2000;
```

---

## SELECT COM ORDER BY

```sql
SELECT id_autor, nome, nacionalidade 
FROM autores 
ORDER BY nome ASC;
```

---

# JOIN

```sql
SELECT 
    l.id_livro AS ID,
    l.titulo AS `Título do Livro`, 
    l.ano_publicacao AS `Ano`, 
    a.nome AS Autor,
    a.nacionalidade AS Nacionalidade
FROM livros l
INNER JOIN autores a ON l.id_autor = a.id_autor;
```

---

# Screenshots

-- Tabela completa

<img width="610" height="173" alt="Captura de tela 2026-05-26 220453" src="https://github.com/user-attachments/assets/5acbee07-0c28-4eb7-b6a4-9f7122103858" />

---


-- CONSULTAS

Select com WHERE

<img width="869" height="140" alt="Captura de tela 2026-05-26 221049" src="https://github.com/user-attachments/assets/a4392186-11d6-4313-a3b5-aed5812f2e24" />


---


Select com ORDER BY

<img width="688" height="160" alt="Captura de tela 2026-05-26 221313" src="https://github.com/user-attachments/assets/cc63cd32-1a7c-45c4-b47d-5863e2877401" />


---

Select com JOIN

<img width="649" height="178" alt="Captura de tela 2026-05-26 221430" src="https://github.com/user-attachments/assets/6f9e5142-cff5-4e8b-8a25-5dab59c0ae1c" />














