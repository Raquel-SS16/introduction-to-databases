-- ============================================================
-- MODULE 2 - SPRINT 2/5
-- SUBCONSULTAS
-- ============================================================
-- Aluno: Rafael Tokashiki Souza
-- Instituicao: UFR
-- Banco: imobiliaria
-- ============================================================

USE imobiliaria;


-- ============================================================
-- SUBQUERY COM COMPARACAO
-- ============================================================
-- Pergunta: quais imoveis a venda custam acima da media dos
-- imoveis a venda da carteira?
--
-- A consulta interna calcula a media e devolve UM valor.
-- A consulta externa compara cada preco com esse valor.
-- O operador > exige um valor unico - por isso a subconsulta
-- usa AVG, que sempre retorna uma linha so.

SELECT
    titulo,
    tipo,
    bairro,
    preco
FROM imoveis
WHERE finalidade = 'Venda'
  AND preco > (
      SELECT AVG(preco)
      FROM imoveis
      WHERE finalidade = 'Venda'
  )
ORDER BY preco DESC;


-- Para conferir o valor que a subconsulta produz:
SELECT ROUND(AVG(preco), 2) AS media_venda
FROM imoveis
WHERE finalidade = 'Venda';


-- ============================================================
-- IN
-- ============================================================
-- Pergunta: quais clientes ja visitaram algum imovel?
--
-- A subconsulta devolve uma LISTA de ids (nao um valor unico),
-- por isso o operador e IN e nao =.

SELECT
    nome,
    telefone,
    interesse
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM visitas
)
ORDER BY nome;


-- ============================================================
-- NOT IN
-- ============================================================
-- Pergunta: quais clientes visitaram imoveis mas nunca
-- fecharam contrato?
--
-- Sao os clientes com interesse demonstrado e negocio nao
-- concretizado - a lista de prioridade para follow-up.
--
-- ATENCAO: NOT IN tem um comportamento perigoso. Se a
-- subconsulta retornar algum NULL, o resultado inteiro vem
-- vazio, sem erro nenhum. Aqui isso nao ocorre porque
-- contratos.id_cliente e NOT NULL, mas em uma coluna que
-- aceita nulos o correto seria usar NOT EXISTS.

SELECT
    cl.nome,
    cl.telefone,
    cl.interesse
FROM clientes AS cl
WHERE cl.id_cliente IN (
      SELECT id_cliente FROM visitas
  )
  AND cl.id_cliente NOT IN (
      SELECT id_cliente FROM contratos
  )
ORDER BY cl.nome;


-- ============================================================
-- EXISTS
-- ============================================================
-- Pergunta: quais proprietarios possuem pelo menos um imovel
-- ainda disponivel na carteira?
--
-- EXISTS nao compara valores: ele apenas verifica se a
-- subconsulta devolveu ALGUMA linha. Assim que encontra a
-- primeira, para de procurar.

SELECT
    p.nome,
    p.telefone,
    p.cidade
FROM proprietarios AS p
WHERE EXISTS (
    SELECT 1
    FROM imoveis AS i
    WHERE i.id_proprietario = p.id_proprietario
      AND i.disponivel = TRUE
)
ORDER BY p.nome;


-- ============================================================
-- NOT EXISTS
-- ============================================================
-- Pergunta: quais corretores ainda nao realizaram nenhuma
-- visita?
--
-- NOT EXISTS e verdadeiro quando a subconsulta NAO devolve
-- nenhuma linha. E a forma segura de perguntar pela ausencia
-- de registro, porque nao sofre o problema de NULL do NOT IN.

SELECT
    co.nome,
    co.creci,
    co.data_admissao
FROM corretores AS co
WHERE NOT EXISTS (
    SELECT 1
    FROM visitas AS v
    WHERE v.id_corretor = co.id_corretor
)
ORDER BY co.data_admissao;


-- ============================================================
-- MAX / MIN
-- ============================================================
-- Pergunta: qual e o imovel mais caro da carteira?
--
-- Nao basta usar MAX(preco) sozinho - isso devolveria apenas
-- o numero, sem dizer de qual imovel. A subconsulta encontra
-- o valor maximo e a consulta externa localiza a linha
-- correspondente.

SELECT
    titulo,
    tipo,
    bairro,
    preco
FROM imoveis
WHERE preco = (
    SELECT MAX(preco)
    FROM imoveis
);


-- O aluguel mais barato disponivel.

SELECT
    titulo,
    bairro,
    preco,
    valor_condominio
FROM imoveis
WHERE finalidade = 'Aluguel'
  AND preco = (
      SELECT MIN(preco)
      FROM imoveis
      WHERE finalidade = 'Aluguel'
  );


-- ============================================================
-- SUBQUERY CORRELACIONADA
-- ============================================================
-- Pergunta: quais imoveis custam acima da media do seu
-- PROPRIO tipo?
--
-- Esta subconsulta e correlacionada porque depende de um valor
-- da consulta externa: i1.tipo. Ela nao roda uma vez so - roda
-- uma vez para CADA linha da consulta externa, calculando a
-- media daquele tipo especifico.
--
-- Comparar uma casa com a media geral nao diz muito, porque a
-- media mistura terrenos e kitnets. Comparar cada casa com a
-- media das casas responde a pergunta real.

SELECT
    i1.titulo,
    i1.tipo,
    i1.preco,
    (SELECT ROUND(AVG(i2.preco), 2)
     FROM imoveis AS i2
     WHERE i2.tipo = i1.tipo) AS media_do_tipo
FROM imoveis AS i1
WHERE i1.preco > (
    SELECT AVG(i2.preco)
    FROM imoveis AS i2
    WHERE i2.tipo = i1.tipo
)
ORDER BY i1.tipo, i1.preco DESC;


-- Segunda correlacionada: quantas visitas cada imovel recebeu.
-- A subconsulta no SELECT roda uma vez por imovel.

SELECT
    i.titulo,
    i.bairro,
    i.preco,
    (SELECT COUNT(*)
     FROM visitas AS v
     WHERE v.id_imovel = i.id_imovel) AS total_visitas
FROM imoveis AS i
ORDER BY total_visitas DESC, i.preco DESC;


-- ============================================================
-- PROBLEMA 1 - JOIN
-- ============================================================
-- Pergunta: quais clientes ja visitaram algum imovel?

SELECT DISTINCT
    cl.nome,
    cl.telefone
FROM clientes AS cl
INNER JOIN visitas AS v
    ON cl.id_cliente = v.id_cliente
ORDER BY cl.nome;


-- ============================================================
-- PROBLEMA 1 - SUBQUERY
-- ============================================================
-- Mesma pergunta, resolvida com subconsulta.

SELECT
    nome,
    telefone
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM visitas
)
ORDER BY nome;


-- ============================================================
-- PROBLEMA 2 - JOIN
-- ============================================================
-- Pergunta: quais imoveis nunca receberam visita?
--
-- Com JOIN, a solucao exige LEFT JOIN mais filtro IS NULL.

SELECT
    i.titulo,
    i.tipo,
    i.bairro,
    i.preco
FROM imoveis AS i
LEFT JOIN visitas AS v
    ON i.id_imovel = v.id_imovel
WHERE v.id_visita IS NULL
ORDER BY i.preco DESC;


-- ============================================================
-- PROBLEMA 2 - SUBQUERY
-- ============================================================
-- Mesma pergunta com NOT EXISTS.

SELECT
    i.titulo,
    i.tipo,
    i.bairro,
    i.preco
FROM imoveis AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM visitas AS v
    WHERE v.id_imovel = i.id_imovel
)
ORDER BY i.preco DESC;


-- ============================================================
-- TESTE OPERACIONAL
-- ============================================================
-- Consulta original: imoveis acima de 300000.

SELECT titulo, tipo, preco
FROM imoveis
WHERE preco > 300000
ORDER BY preco DESC;


-- Mesma consulta com o filtro alterado para 1000000.

SELECT titulo, tipo, preco
FROM imoveis
WHERE preco > 1000000
ORDER BY preco DESC;


-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
