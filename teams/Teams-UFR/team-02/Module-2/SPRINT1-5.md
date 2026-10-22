# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados
**Módulo:** 2
**Modalidade:** Atividade individual
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# 2. Identificação

**Nome completo:**

> Rafael Tokashiki Souza

**Branch:**

```text
team-02
```

**Nome do banco:**

```text
imobiliaria
```

**Tema do projeto:**

> Imobiliária — gestão de imóveis, proprietários, clientes e negociações,
> desenvolvida ao longo do Module-1.

---

# 3. Retomada do banco

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | proprietarios | `id_proprietario` | Nenhuma — tabela independente |
| 2 | clientes | `id_cliente` | Nenhuma — tabela independente |
| 3 | corretores | `id_corretor` | Nenhuma — tabela independente |
| 4 | imoveis | `id_imovel` | `id_proprietario` → proprietarios |
| 5 | visitas | `id_visita` | `id_imovel`, `id_cliente`, `id_corretor` |
| 6 | contratos | `id_contrato` | `id_imovel`, `id_cliente`, `id_corretor` |

As tabelas `visitas` e `contratos` são associativas: cada uma carrega três
chaves estrangeiras e resolve o relacionamento N:N entre clientes e imóveis.
São elas que permitem a maior parte dos `JOIN` desta Sprint.

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| proprietarios | 1:N | imoveis | `imoveis.id_proprietario` |
| imoveis | 1:N | visitas | `visitas.id_imovel` |
| clientes | 1:N | visitas | `visitas.id_cliente` |
| corretores | 1:N | visitas | `visitas.id_corretor` |
| imoveis | 1:N | contratos | `contratos.id_imovel` |
| clientes | 1:N | contratos | `contratos.id_cliente` |
| corretores | 1:N | contratos | `contratos.id_corretor` |

---

# 5. INNER JOIN

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Quem é o proprietário de cada imóvel da carteira e como entrar em contato
> com ele?

**Tabelas utilizadas:**

```text
imoveis, proprietarios
```

**PK/FK utilizadas:**

```text
PK: proprietarios.id_proprietario
FK: imoveis.id_proprietario
```

**SQL:**

```sql
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
```

**Explique o resultado:**

> Retorna os 8 imóveis, cada um com o nome e o telefone do seu dono. O
> `INNER JOIN` funciona aqui porque a coluna `id_proprietario` é `NOT NULL`:
> todo imóvel tem obrigatoriamente um proprietário cadastrado, então nenhum
> registro fica de fora.
>
> Na prática, esta é a consulta que o corretor usa quando precisa ligar para o
> dono — antes, a tabela `imoveis` guardava apenas o número do proprietário,
> que não serve para nada em um telefonema.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais contratos foram fechados e qual corretor intermediou cada um?

```sql
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
```

**Explique:**

> Retorna os três contratos com o nome e o CRECI do corretor responsável. O
> `AS` cria apelidos para as tabelas (`c` e `co`), o que encurta a escrita
> quando o mesmo campo existe em mais de uma tabela — tanto `contratos` quanto
> `corretores` têm uma coluna `valor`? Não, mas ambas poderiam; o apelido
> elimina a ambiguidade antes que ela apareça.

---

# 6. LEFT JOIN

## Consulta obrigatória

**Pergunta:**

> Todos os corretores da equipe realizaram visitas? Quem ainda não atendeu
> nenhum cliente?

```sql
SELECT
    co.nome            AS corretor,
    co.creci,
    v.id_visita,
    v.data_visita
FROM corretores AS co
LEFT JOIN visitas AS v
    ON co.id_corretor = v.id_corretor
ORDER BY co.nome;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Permite ver exatamente o que o `INNER JOIN` esconderia. O `LEFT JOIN` mantém
> **todos** os registros da tabela da esquerda (`corretores`), mesmo os que não
> têm nenhuma visita correspondente. Nesses casos, as colunas vindas de
> `visitas` aparecem preenchidas com `NULL`.
>
> Com `INNER JOIN`, os corretores sem visita simplesmente desapareceriam do
> resultado — e são justamente eles a resposta da pergunta. É a diferença entre
> "quem trabalhou" e "quem não trabalhou": o segundo grupo só existe no
> resultado se eu usar `LEFT JOIN`.
>
> No meu banco, os corretores Eduardo Nakamura e Rafael Tokashiki aparecem com
> `NULL` nas colunas de visita, porque nenhuma visita ativa está vinculada a
> eles.

Criei também uma versão resumida com contagem:

```sql
SELECT
    co.nome AS corretor,
    COUNT(v.id_visita) AS total_visitas
FROM corretores AS co
LEFT JOIN visitas AS v
    ON co.id_corretor = v.id_corretor
GROUP BY co.id_corretor, co.nome
ORDER BY total_visitas DESC;
```

Um detalhe importante aqui: usei `COUNT(v.id_visita)` e não `COUNT(*)`. O
`COUNT` de uma coluna ignora valores nulos, então retorna **0** para quem não
tem visita. Já `COUNT(*)` contaria a própria linha gerada pelo `LEFT JOIN` e
retornaria **1** mesmo para quem nunca atendeu ninguém — um resultado errado
que passaria despercebido.

---

# 7. RIGHT JOIN

## Consulta obrigatória

**Pergunta:**

> Quais imóveis da carteira ainda não receberam nenhuma visita?

```sql
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
```

**Explique o resultado:**

> O `RIGHT JOIN` mantém todos os registros da tabela da **direita** (`imoveis`),
> mesmo quando não existe visita correspondente. O filtro `WHERE v.id_visita IS
> NULL` isola justamente essas linhas sem correspondência — os imóveis que
> ninguém foi visitar.
>
> No meu banco, retorna o terreno em condomínio e a sala comercial. Para a
> imobiliária, isso é um alerta: imóveis parados sem interesse podem indicar
> preço acima do mercado ou anúncio mal divulgado.
>
> Conceitualmente, `RIGHT JOIN` é o espelho do `LEFT JOIN`. A mesma pergunta
> poderia ser escrita como `FROM imoveis LEFT JOIN visitas`, invertendo a ordem
> das tabelas. Usei `RIGHT JOIN` aqui porque a Sprint pede, mas na prática a
> maioria dos desenvolvedores prefere sempre `LEFT JOIN` e reorganiza a ordem
> das tabelas — fica mais fácil de ler, porque a tabela principal aparece
> primeiro.

---

# 8. JOIN com três ou mais tabelas

## Consulta 1

**Pergunta:**

> Qual foi o histórico completo de visitas, com cliente, imóvel e corretor?

```sql
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
```

A tabela `visitas` é o centro do relacionamento: ela guarda as três chaves
estrangeiras, e cada `JOIN` resolve uma delas. Por isso a consulta começa por
ela — partir de `clientes`, por exemplo, obrigaria a passar por `visitas` antes
de chegar em `imoveis`.

## Consulta 2

**Pergunta:**

> Nos contratos fechados, quem comprou ou alugou, qual imóvel, de qual
> proprietário e por meio de qual corretor?

```sql
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
```

Esta percorre **cinco** tabelas e mostra a operação inteira da imobiliária em
uma linha por negócio. Repare no segundo `JOIN`: ele não liga `contratos` a
`proprietarios` diretamente, porque não existe FK entre as duas. A ligação
passa por `imoveis` — é o imóvel que conhece seu dono. Esse encadeamento é o
que torna a consulta interessante: para chegar ao proprietário, preciso
atravessar uma tabela intermediária.

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais imóveis ainda disponíveis já receberam visita de algum cliente?

```sql
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
```

**Explique o filtro:**

> O `WHERE i.disponivel = TRUE` filtra sobre uma coluna da tabela `imoveis`,
> mesmo que a consulta tenha começado por `visitas`. Depois do `JOIN`, o banco
> trabalha com um conjunto único de linhas, então o filtro pode usar qualquer
> coluna de qualquer tabela envolvida.
>
> Comercialmente, essa consulta identifica os imóveis com interesse comprovado
> que ainda não foram fechados — a lista de prioridade para o follow-up da
> equipe. Sem o filtro, apareceriam também os imóveis já vendidos ou alugados,
> onde não há mais nada a fazer.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Como fica a carteira organizada por proprietário e, dentro de cada
> proprietário, do imóvel mais caro ao mais barato?

```sql
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
```

A ordenação por duas colunas agrupa visualmente os imóveis de cada dono e, dentro
de cada bloco, mostra primeiro o mais valioso. A segunda coluna do `ORDER BY` só
entra em ação para desempatar linhas que têm o mesmo valor na primeira.

---

# 11. JOIN + GROUP BY + agregação

**Pergunta:**

> Quantos imóveis cada proprietário tem conosco e qual o valor total da
> carteira de cada um?

```sql
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
```

**Explique o agrupamento:**

> O `GROUP BY` junta todas as linhas que pertencem ao mesmo proprietário e
> aplica `COUNT`, `SUM` e `AVG` a cada grupo separadamente, em vez de somar a
> tabela inteira.
>
> Agrupei por `p.id_proprietario, p.nome` e não apenas pelo nome. O motivo é
> que o `id` é a chave primária e garante unicidade: se dois proprietários
> tivessem o mesmo nome, agrupar só por nome fundiria os dois em um grupo só,
> produzindo um total errado. Incluir o `id` no `GROUP BY` resolve isso, e o
> nome entra junto apenas para poder aparecer no `SELECT`.
>
> Sem o `JOIN`, o resultado mostraria apenas números de identificação — inútil
> em um relatório que alguém vai ler.

---

# 13. Consulta mais útil

**Pergunta:**

> Quais imóveis da carteira ainda não receberam nenhuma visita?

```sql
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
```

**Por que ela é útil?**

> Porque responde a uma pergunta que as consultas do Module-1 não conseguiam
> responder: a ausência de registro. Todas as consultas anteriores mostravam o
> que **existe** — imóveis cadastrados, visitas realizadas, contratos fechados.
> Esta mostra o que **não** aconteceu.
>
> Para a imobiliária, um imóvel parado há meses sem nenhuma visita é um
> problema concreto: ou o preço está acima do mercado, ou o anúncio está mal
> divulgado, ou as fotos são ruins. A consulta transforma uma lacuna nos dados
> em uma lista de ação.

---

# 14. Validação prática obrigatória

Escolhi a consulta do histórico de visitas:

```sql
SELECT
    v.data_visita,
    cl.nome      AS cliente,
    i.titulo     AS imovel,
    co.nome      AS corretor
FROM visitas AS v
INNER JOIN clientes   AS cl ON v.id_cliente  = cl.id_cliente
INNER JOIN imoveis    AS i  ON v.id_imovel   = i.id_imovel
INNER JOIN corretores AS co ON v.id_corretor = co.id_corretor
ORDER BY v.data_visita;
```

**1. Quais tabelas participam**

Quatro: `visitas`, `clientes`, `imoveis` e `corretores`. A tabela `visitas` é o
ponto de partida porque é ela que conecta as outras três.

**2. Qual PK está sendo utilizada**

Três chaves primárias são usadas no lado direito de cada `ON`:
`clientes.id_cliente`, `imoveis.id_imovel` e `corretores.id_corretor`. A PK da
própria tabela `visitas` (`id_visita`) não participa do relacionamento — ela
apenas identifica cada visita individualmente.

**3. Qual FK está sendo utilizada**

As três chaves estrangeiras da tabela `visitas`: `id_cliente`, `id_imovel` e
`id_corretor`. Cada uma aparece no lado esquerdo de um `ON`.

**4. O que a cláusula ON faz**

O `ON` define a condição que determina quais linhas de uma tabela correspondem
a quais linhas da outra. Em `ON v.id_cliente = cl.id_cliente`, o banco procura,
para cada visita, a linha de `clientes` cujo `id_cliente` tem o mesmo valor
guardado em `visitas.id_cliente`.

Sem o `ON`, o banco não teria critério nenhum e combinaria **todas** as linhas
de uma tabela com **todas** as linhas da outra — um produto cartesiano. Com 5
visitas e 4 clientes, isso geraria 20 linhas em vez de 5.

**5. O que ocorreria se a condição de relacionamento estivesse errada**

Depende do tipo de erro, e os três casos são bem diferentes:

- **Coluna inexistente** (`ON v.id_cliente = cl.id_usuario`): erro de sintaxe,
  `Unknown column`. O banco recusa e nada executa. É o melhor caso, porque o
  problema fica visível na hora.
- **Colunas trocadas** (`ON v.id_cliente = cl.id_cliente` virando
  `ON v.id_imovel = cl.id_cliente`): a consulta **executa normalmente** e
  devolve dados errados, relacionando clientes com imóveis por coincidência
  numérica. Não há erro nenhum na tela — é o caso mais perigoso, porque o
  resultado parece legítimo.
- **Condição ausente** (`CROSS JOIN` acidental): produto cartesiano, com todas
  as combinações possíveis. Percebe-se pelo número absurdo de linhas.

O segundo caso é o que justifica conferir o resultado de um `JOIN` antes de
confiar nele, e não apenas verificar se o comando rodou.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT
    co.nome AS corretor,
    COUNT(v.id_visita) AS total_visitas
FROM corretores AS co
LEFT JOIN visitas AS v
    ON co.id_corretor = v.id_corretor
GROUP BY co.id_corretor, co.nome
ORDER BY total_visitas DESC;
```

**Resultado esperado:**

> Os cinco corretores listados, incluindo os que não realizaram visita alguma,
> com `0` na coluna de total.

**Resultado obtido:**

> Os cinco corretores apareceram. Paulo Henrique Dias e Camila Rocha Barbosa
> com duas visitas cada, Patricia Gomes Reis com uma, e Eduardo Nakamura e
> Rafael Tokashiki com zero.
>
> Para confirmar que o `LEFT JOIN` era mesmo necessário, troquei por
> `INNER JOIN` e executei de novo: o resultado caiu para três corretores — os
> dois com zero visitas desapareceram. Isso comprovou na prática a diferença
> entre os dois tipos de junção.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Na primeira versão da contagem de visitas por corretor, os corretores sem visita apareciam com total `1` em vez de `0` | Usei `COUNT(*)`, que conta a linha gerada pelo `LEFT JOIN` mesmo quando as colunas da tabela da direita são todas nulas | Troquei por `COUNT(v.id_visita)`, que ignora valores nulos e retorna `0` corretamente |
| `Column 'nome' in field list is ambiguous` ao juntar `clientes` e `corretores` | As duas tabelas possuem uma coluna chamada `nome`, e o banco não sabia a qual eu me referia | Uso de apelidos de tabela (`cl.nome`, `co.nome`) com `AS`, qualificando cada coluna |
| A consulta de contratos com proprietário não funcionava ligando as duas tabelas diretamente | Não existe chave estrangeira entre `contratos` e `proprietarios` | A ligação foi feita passando por `imoveis`, que é a tabela que conhece o proprietário: `contratos → imoveis → proprietarios` |
| Ao agrupar por `p.nome`, percebi o risco de fundir dois proprietários homônimos em um grupo só | O nome não é um campo único na tabela | Passei a agrupar por `p.id_proprietario, p.nome`, usando a chave primária como critério real de agrupamento |

---

# 19. Checklist

- [x] utilizei o mesmo banco do Module-1;
- [x] identifiquei PKs e FKs;
- [x] produzi 2 `INNER JOIN`;
- [x] produzi 1 `LEFT JOIN`;
- [x] produzi 1 `RIGHT JOIN`;
- [x] produzi consultas com 3 ou mais tabelas;
- [x] utilizei `WHERE`;
- [x] utilizei `ORDER BY`;
- [x] utilizei agregação e `GROUP BY`;
- [x] as consultas respondem perguntas reais;
- [x] testei tudo no MySQL Workbench;
- [x] consigo explicar as consultas;
- [x] salvei `SPRINT1-5.md`;
- [x] salvei `SPRINT1-5.sql`.
