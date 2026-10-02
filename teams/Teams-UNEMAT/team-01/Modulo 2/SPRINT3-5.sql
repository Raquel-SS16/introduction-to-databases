-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluna: Raquel Silva dos Santos
-- Banco: series_watchlist_db

USE series_watchlist_db;

-- VIEW 1
-- Visão simples: Séries recentes (lançadas a partir de 2020)
CREATE VIEW vw_series_recentes AS
SELECT 
    id_serie,
    titulo,
    genero,
    ano_lancamento
FROM serie
WHERE ano_lancamento >= 2020;

-- VIEW 2
-- Visão com JOIN: Séries com o nome de suas respectivas plataformas
CREATE VIEW vw_detalhes_series_plataforma AS
SELECT 
    s.id_serie,
    s.titulo,
    s.genero,
    s.ano_lancamento,
    p.nome_plataforma
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;

-- VIEW 3
-- Visão com Agregação (GROUP BY): Média de notas e quantidade de avaliações por série
CREATE VIEW vw_resumo_avaliacoes_series AS
SELECT 
    s.id_serie,
    s.titulo,
    COUNT(w.id_usuario) AS total_avaliacoes,
    ROUND(AVG(w.nota), 2) AS media_nota
FROM serie AS s
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY 
    s.id_serie, 
    s.titulo;

-- CONSULTAS SOBRE AS VIEWS
-- Consulta 1: Selecionando séries recentes
SELECT * FROM vw_series_recentes;

-- Consulta 2: Selecionando séries com detalhes de plataforma
SELECT * FROM vw_detalhes_series_plataforma;

-- Consulta 3: Filtrando apenas séries com nota média superior ou igual a 8.5
SELECT 
    titulo,
    media_nota,
    total_avaliacoes
FROM vw_resumo_avaliacoes_series
WHERE media_nota >= 8.5
ORDER BY media_nota DESC;

-- CREATE OR REPLACE VIEW
-- Atualização da VIEW 1 para incluir também o id_plataforma
CREATE OR REPLACE VIEW vw_series_recentes AS
SELECT 
    id_serie,
    titulo,
    genero,
    ano_lancamento,
    id_plataforma
FROM serie
WHERE ano_lancamento >= 2020;

-- VIEW TEMPORÁRIA
-- Visão simples para checagem rápida de usuários com email da plataforma
CREATE OR REPLACE VIEW vw_temp_usuarios_ativos AS
SELECT 
    id_usuario,
    nome,
    email
FROM usuario
WHERE email IS NOT NULL;

-- DROP VIEW
-- Remoção de visões do banco de dados
DROP VIEW IF EXISTS vw_temp_usuarios_ativos;
DROP VIEW IF EXISTS vw_series_recentes;

-- VALIDAÇÃO
-- Teste de consulta final na visão agregada mantida
SELECT 
    titulo, 
    total_avaliacoes, 
    media_nota 
FROM vw_resumo_avaliacoes_series;