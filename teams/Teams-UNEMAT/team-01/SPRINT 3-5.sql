-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: RAQUEL SILVA DOS SANTOS
-- Banco: series_watchlist_db


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE series_watchlist_db;


-- ============================================================
-- INSERTS — TABELA 1: PLATAFORMA (Independente)
-- ============================================================

INSERT INTO plataforma (nome_plataforma)
VALUES 
    ('Netflix'),
    ('HBO Max'),
    ('Prime Video'),
    ('Disney+'),
    ('Apple TV+'),
    ('Paramount+');


-- ============================================================
-- INSERTS — TABELA 2: USUARIO (Independente)
-- ============================================================

INSERT INTO usuario (nome, email, data_cadastro)
VALUES 
    ('Lucas Silveira', 'lucas.silveira@email.com', '2024-01-15'),
    ('Beatriz Lima', 'beatriz.lima@email.com', '2024-02-10'),
    ('Carlos Eduardo', 'carlos.edu@email.com', '2024-02-28'),
    ('Mariana Santos', 'mariana.santos@email.com', '2024-03-05'),
    ('Rafael Souza', 'rafael.souza@email.com', '2024-03-12'),
    ('Fernanda Costa', 'fernanda.costa@email.com', '2024-03-20');


-- ============================================================
-- INSERTS — TABELA 3: SERIE (Depende de PLATAFORMA)
-- ============================================================

INSERT INTO serie (titulo, genero, ano_lancamento, id_plataforma, pais_origem)
VALUES 
    ('Stranger Things', 'Ficção Científica', 2016, 1, 'EUA'),
    ('The Last of Us', 'Drama / Pós-Apocalíptico', 2023, 2, 'EUA'),
    ('The Boys', 'Ação / Super-heróis', 2019, 3, 'EUA'),
    ('The Mandalorian', 'Ficção Científica / Aventura', 2019, 4, 'EUA'),
    ('Severance', 'Suspense / Ficção Científica', 2022, 5, 'EUA'),
    ('Dark', 'Ficção Científica / Mistério', 2017, 1, 'Alemanha'),
    ('Succession', 'Drama', 2018, 2, 'EUA'),
    ('Serie Cancelada Teste', 'Comédia', 2020, 6, 'EUA');


-- ============================================================
-- INSERTS — TABELA 4: ITEM_WATCHLIST (Depende de USUARIO e SERIE)
-- ============================================================

INSERT INTO item_watchlist (id_usuario, id_serie, status_assistindo)
VALUES 
    (1, 1, 'Concluído'),
    (1, 2, 'Assistindo'),
    (1, 5, 'Quero Ver'),
    (2, 2, 'Concluído'),
    (2, 6, 'Concluído'),
    (3, 3, 'Assistindo'),
    (3, 4, 'Quero Ver'),
    (4, 1, 'Assistindo'),
    (4, 7, 'Concluído'),
    (5, 5, 'Quero Ver'),
    (6, 8, 'Quero Ver');


-- ============================================================
-- VERIFICAÇÕES
-- ============================================================

SELECT * FROM plataforma;
SELECT * FROM usuario;
SELECT * FROM serie;
SELECT * FROM item_watchlist;


-- ============================================================
-- UPDATES
-- ============================================================

-- 1. Atualiza status de uma série na watchlist de um usuário específico
UPDATE item_watchlist
SET status_assistindo = 'Concluído'
WHERE id_usuario = 1 AND id_serie = 2;

-- 2. Atualiza o e-mail de um usuário
UPDATE usuario
SET email = 'carlos.eduardo.dev@email.com'
WHERE id_usuario = 3;

-- 3. Atualiza o gênero de catálogo de uma série
UPDATE serie
SET genero = 'Drama / Ficção Científica'
WHERE id_serie = 2;


-- ============================================================
-- DELETES
-- ============================================================

-- 1. Remove primeiro a dependência na tabela associativa filha
DELETE FROM item_watchlist
WHERE id_usuario = 6 AND id_serie = 8;

-- 2. Remove o registro pai na tabela serie (agora sem violar Foreign Key)
DELETE FROM serie
WHERE id_serie = 8;


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

SELECT * FROM plataforma;
SELECT * FROM usuario;
SELECT * FROM serie;
SELECT * FROM item_watchlist;