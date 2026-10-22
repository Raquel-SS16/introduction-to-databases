-- ============================================================
-- MODULE 2 - SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS
-- ============================================================
-- Aluno: Rafael Tokashiki Souza
-- Instituicao: UFR
-- Banco: imobiliaria
-- ============================================================

USE imobiliaria;


-- ============================================================
-- INNER JOIN 1
-- ============================================================
-- Pergunta: quem é o proprietario de cada imovel da carteira
-- e como entrar em contato com ele?
--
-- O INNER JOIN liga imoveis.id_proprietario (FK) a
-- proprietarios.id_proprietario (PK). Retorna apenas os
-- registros que possuem correspondencia nas duas tabelas.

SELECT
    i.titulo        AS imovel,
    i.tipo,
    i.preco,
    p.nome          AS proprietario,
    p.telefone
FROM imoveis AS i
INNER JOIN proprietarios AS p
    ON i.id_proprietario = p.id_proprietario
ORDER BY p.nome, i.preco DESC;


-- ============================================================
-- INNER JOIN 2
-- ============================================================
-- Pergunta: quais contratos foram fechados e qual corretor
-- intermediou cada um?
--
-- Liga contratos.id_corretor (FK) a corretores.id_corretor (PK).

SELECT
    c.id_contrato,
    c.tipo_contrato,
    c.valor,
    c.data_inicio,
    co.nome   AS corretor,
    co.creci
FROM contratos AS c
INNER JOIN corretores AS co
    ON c.id_corretor = co.id_corretor
ORDER BY c.data_inicio;


-- ============================================================
-- LEFT JOIN
-- ============================================================
-- Pergunta: todos os corretores da equipe realizaram visitas?
-- Quem ainda nao atendeu nenhum cliente?
--
-- O LEFT JOIN mantem TODOS os corretores, mesmo os que nao
-- possuem visita registrada. Nesses casos as colunas vindas
-- de visitas aparecem como NULL.
--
-- Com INNER JOIN, os corretores sem visita simplesmente
-- desapareceriam do resultado - e justamente eles sao a
-- resposta da pergunta.

SELECT
    co.nome            AS corretor,
    co.creci,
    v.id_visita,
    v.data_visita
FROM corretores AS co
LEFT JOIN visitas AS v
    ON co.id_corretor = v.id_corretor
ORDER BY co.nome;


-- Versao resumida: quantas visitas cada corretor realizou,
-- incluindo os que realizaram zero.
-- COUNT(v.id_visita) conta apenas linhas nao nulas, por isso
-- retorna 0 para quem nao tem visita. COUNT(*) retornaria 1,
-- porque contaria a propria linha do LEFT JOIN.

SELECT
    co.nome AS corretor,
    COUNT(v.id_visita) AS total_visitas
FROM corretores AS co
LEFT JOIN visitas AS v
    ON co.id_corretor = v.id_corretor
GROUP BY co.id_corretor, co.nome
ORDER BY total_visitas DESC;


-- ============================================================
-- RIGHT JOIN
-- ============================================================
-- Pergunta: quais imoveis da carteira ainda nao receberam
-- nenhuma visita?
--
-- O RIGHT JOIN mantem todos os registros da tabela da DIREITA
-- (imoveis), mesmo sem visita correspondente.
-- E o espelho do LEFT JOIN: a mesma pergunta poderia ser
-- escrita como "FROM imoveis LEFT JOIN visitas".

SELECT
    i.titulo       AS imovel,
    i.tipo,
    i.bairro,
    i.preco,
    v.id_visita,
    v.data_visita
FROM visitas AS v
RIGHT JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel
ORDER BY i.titulo;


-- Apenas os imoveis sem visita alguma.
-- O filtro IS NULL isola as linhas em que o RIGHT JOIN nao
-- encontrou correspondencia.

SELECT
    i.titulo  AS imovel_sem_visita,
    i.tipo,
    i.bairro,
    i.preco
FROM visitas AS v
RIGHT JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel
WHERE v.id_visita IS NULL
ORDER BY i.preco DESC;


-- ============================================================
-- JOIN COM 3+ TABELAS - 1
-- ============================================================
-- Pergunta: qual foi o historico completo de visitas, com
-- cliente, imovel e corretor?
--
-- Sao necessarias quatro tabelas. A tabela visitas e o centro
-- do relacionamento: ela guarda as tres chaves estrangeiras
-- que ligam cliente, imovel e corretor.

SELECT
    v.data_visita,
    cl.nome      AS cliente,
    i.titulo     AS imovel,
    i.bairro,
    co.nome      AS corretor,
    v.observacao
FROM visitas AS v
INNER JOIN clientes   AS cl ON v.id_cliente  = cl.id_cliente
INNER JOIN imoveis    AS i  ON v.id_imovel   = i.id_imovel
INNER JOIN corretores AS co ON v.id_corretor = co.id_corretor
ORDER BY v.data_visita;


-- ============================================================
-- JOIN COM 3+ TABELAS - 2
-- ============================================================
-- Pergunta: nos contratos fechados, quem comprou ou alugou,
-- qual imovel, de qual proprietario e por meio de qual corretor?
--
-- Esta consulta percorre cinco tabelas e representa a operacao
-- completa da imobiliaria em uma unica linha por negocio.

SELECT
    c.tipo_contrato,
    i.titulo    AS imovel,
    p.nome      AS proprietario,
    cl.nome     AS cliente,
    co.nome     AS corretor,
    c.valor,
    c.data_inicio,
    c.data_fim
FROM contratos AS c
INNER JOIN imoveis       AS i  ON c.id_imovel       = i.id_imovel
INNER JOIN proprietarios AS p  ON i.id_proprietario = p.id_proprietario
INNER JOIN clientes      AS cl ON c.id_cliente      = cl.id_cliente
INNER JOIN corretores    AS co ON c.id_corretor     = co.id_corretor
ORDER BY c.data_inicio;


-- ============================================================
-- JOIN + WHERE
-- ============================================================
-- Pergunta: quais imoveis AINDA DISPONIVEIS ja receberam
-- visita de algum cliente?
--
-- Esses sao os imoveis que despertam interesse mas ainda nao
-- foram fechados - a prioridade comercial da equipe.

SELECT
    i.titulo    AS imovel,
    i.bairro,
    i.preco,
    cl.nome     AS cliente_que_visitou,
    v.data_visita,
    v.observacao
FROM visitas AS v
INNER JOIN imoveis  AS i  ON v.id_imovel  = i.id_imovel
INNER JOIN clientes AS cl ON v.id_cliente = cl.id_cliente
WHERE i.disponivel = TRUE
ORDER BY v.data_visita DESC;


-- ============================================================
-- JOIN + ORDER BY
-- ============================================================
-- Pergunta: como fica a carteira organizada por proprietario
-- e, dentro de cada proprietario, do imovel mais caro ao mais
-- barato?

SELECT
    p.nome      AS proprietario,
    p.cidade,
    i.titulo    AS imovel,
    i.tipo,
    i.preco
FROM proprietarios AS p
INNER JOIN imoveis AS i
    ON p.id_proprietario = i.id_proprietario
ORDER BY p.nome ASC, i.preco DESC;


-- ============================================================
-- JOIN + GROUP BY + AGREGACAO
-- ============================================================
-- Pergunta: quantos imoveis cada proprietario tem conosco e
-- qual o valor total da carteira de cada um?
--
-- O JOIN traz o nome do proprietario; sem ele o agrupamento
-- mostraria apenas o id. COUNT e SUM sao aplicados a cada
-- grupo separadamente.

SELECT
    p.nome                   AS proprietario,
    COUNT(i.id_imovel)       AS total_imoveis,
    SUM(i.preco)             AS valor_total_carteira,
    ROUND(AVG(i.preco), 2)   AS valor_medio
FROM proprietarios AS p
INNER JOIN imoveis AS i
    ON p.id_proprietario = i.id_proprietario
GROUP BY p.id_proprietario, p.nome
ORDER BY valor_total_carteira DESC;


-- Faturamento por corretor: soma dos contratos intermediados.

SELECT
    co.nome                  AS corretor,
    COUNT(c.id_contrato)     AS contratos_fechados,
    SUM(c.valor)             AS valor_total_intermediado
FROM corretores AS co
INNER JOIN contratos AS c
    ON co.id_corretor = c.id_corretor
GROUP BY co.id_corretor, co.nome
ORDER BY valor_total_intermediado DESC;


-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
