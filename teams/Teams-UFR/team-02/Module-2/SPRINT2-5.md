# SPRINT 2/5 — Subconsultas e Consultas Avançadas

**Disciplina:** Laboratório de Banco de Dados
**Módulo:** 2
**Modalidade:** Atividade individual
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# 1. Identificação

**Nome completo:**

> Rafael Tokashiki Souza

**Banco utilizado:**

```text
imobiliaria
```

---

# 3. Perguntas que exigem subconsulta

1. Quais imóveis à venda custam acima da média dos imóveis à venda?
2. Quais clientes já visitaram algum imóvel?
3. Quais clientes visitaram imóveis mas nunca fecharam contrato?
4. Quais proprietários possuem pelo menos um imóvel ainda disponível?
5. Quais corretores ainda não realizaram nenhuma visita?
6. Qual é o imóvel mais caro da carteira?
7. Quais imóveis custam acima da média do seu próprio tipo?

---

# 4. Subconsulta com comparação

**Pergunta:**

> Quais imóveis à venda custam acima da média dos imóveis à venda da carteira?

```sql
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
```

**Explique primeiro a consulta interna:**

> A consulta interna percorre todos os imóveis com finalidade `Venda` e calcula
> a média dos preços. Ela devolve **um único valor** — um número só, não uma
> lista nem uma tabela.
>
> Repare que o filtro `WHERE finalidade = 'Venda'` aparece nas duas consultas.
> Sem ele na interna, a média misturaria preços de venda (centenas de milhares)
> com aluguéis (centenas de reais), e a comparação perderia o sentido: todos os
> imóveis à venda ficariam acima dessa média distorcida.

**Depois explique a consulta externa:**

> A consulta externa compara o preço de cada imóvel à venda com o valor que a
> interna produziu, e retorna apenas os que estão acima.
>
> O operador `>` exige um valor único do lado direito — por isso a subconsulta
> precisa usar uma função de agregação. Se ela devolvesse vários preços, o MySQL
> responderia `Subquery returns more than 1 row`.
>
> A ordem de execução é: primeiro a interna, uma vez só; depois a externa, usando
> aquele resultado como se fosse um número escrito ali. É essa independência que
> diferencia esta subconsulta da correlacionada da seção 10.

---

# 5. Subconsulta com IN

**Pergunta:**

> Quais clientes já visitaram algum imóvel?

```sql
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
```

**Explique:**

> Aqui a subconsulta devolve uma **lista** de identificadores, não um valor
> único: todos os `id_cliente` que aparecem na tabela `visitas`. Por isso o
> operador é `IN` e não `=`.
>
> A diferença importa. `=` compara com um valor; `IN` verifica se o valor está
> dentro de um conjunto. Usar `=` aqui daria erro, porque existem várias visitas
> e portanto vários ids.
>
> Um detalhe: a tabela `visitas` tem ids repetidos — o cliente 1 aparece duas
> vezes, porque visitou dois imóveis. O `IN` não se incomoda com repetição, ele
> só verifica pertencimento. Já em um `JOIN`, essa repetição duplicaria o
> cliente no resultado, e eu precisaria de `DISTINCT` para corrigir.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais clientes visitaram imóveis mas nunca fecharam contrato?

```sql
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
```

**Que registros você está procurando?**

> Clientes com interesse demonstrado e negócio não concretizado. Visitaram
> algum imóvel, mas não assinaram nada — a lista exata de quem merece um
> follow-up da equipe.
>
> A consulta combina duas subconsultas: a primeira com `IN` garante que a pessoa
> visitou; a segunda com `NOT IN` elimina quem já fechou. Sozinho, o `NOT IN`
> traria também os clientes que nunca apareceram, que são outro grupo.

**Uma armadilha do `NOT IN` que vale registrar:**

Se a subconsulta devolver algum `NULL`, o `NOT IN` retorna **resultado vazio** —
sem erro, sem aviso, sem nenhuma pista do que aconteceu.

O motivo é lógico: `x NOT IN (1, 2, NULL)` significa `x <> 1 AND x <> 2 AND x <>
NULL`. Como qualquer comparação com `NULL` resulta em "desconhecido" em vez de
verdadeiro, a condição inteira nunca é satisfeita.

No meu banco isso não acontece, porque `contratos.id_cliente` foi declarada
`NOT NULL` lá na Sprint 2/5 do Module-1. Mas se a coluna aceitasse nulos, o
correto seria usar `NOT EXISTS`, que não tem esse problema.

---

# 7. EXISTS

**Pergunta:**

> Quais proprietários possuem pelo menos um imóvel ainda disponível na carteira?

```sql
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
```

O `EXISTS` funciona de um jeito diferente das subconsultas anteriores: ele não
compara valores, apenas verifica se a subconsulta devolveu **alguma linha**.

Por isso escrevi `SELECT 1` em vez de `SELECT id_imovel`. O conteúdo retornado é
irrelevante — o banco só quer saber se existe ou não. Poderia ser `SELECT *`,
`SELECT 1` ou `SELECT 'qualquer coisa'`, o resultado seria o mesmo.

Outra característica: o `EXISTS` para de procurar assim que encontra a primeira
correspondência. Não precisa percorrer todos os imóveis do proprietário para
responder "sim, ele tem pelo menos um".

---

# 8. NOT EXISTS

**Pergunta:**

> Quais corretores ainda não realizaram nenhuma visita?

```sql
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
```

**Explique a diferença em relação a `EXISTS`:**

> É a negação. `EXISTS` é verdadeiro quando a subconsulta devolve pelo menos uma
> linha; `NOT EXISTS` é verdadeiro quando ela não devolve nenhuma.
>
> Na prática, `EXISTS` responde "quem tem" e `NOT EXISTS` responde "quem não
> tem". A segunda pergunta costuma ser mais difícil de formular, porque a
> ausência de registro não aparece em uma consulta comum — exatamente o mesmo
> problema que o `LEFT JOIN` resolve na Sprint 1.
>
> E aqui está a vantagem sobre o `NOT IN`: o `NOT EXISTS` compara linha a linha
> e não se confunde com valores nulos. Se `visitas.id_corretor` pudesse ser
> `NULL`, o `NOT IN` devolveria vazio silenciosamente, enquanto o `NOT EXISTS`
> continuaria funcionando corretamente. Por isso, para perguntas de ausência,
> `NOT EXISTS` é a escolha mais segura.

No meu banco, retorna Eduardo Nakamura e Rafael Tokashiki — os mesmos dois
corretores que apareceram com `NULL` no `LEFT JOIN` da Sprint 1. Duas técnicas
diferentes chegando ao mesmo resultado.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual é o imóvel mais caro da carteira?

```sql
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
```

**Explique:**

> Esta é a situação clássica em que a subconsulta é indispensável. Usar
> `SELECT MAX(preco) FROM imoveis` sozinho devolveria apenas o número —
> R$ 1.150.000,00 — sem dizer de qual imóvel se trata.
>
> E não dá para escrever `SELECT titulo, MAX(preco) FROM imoveis`: o MySQL
> aceitaria o comando, mas o `titulo` retornado seria de uma linha arbitrária,
> não necessariamente a do imóvel mais caro. É um erro que não gera mensagem
> nenhuma.
>
> A solução em duas etapas resolve: a subconsulta descobre **qual é** o valor
> máximo, e a consulta externa localiza **qual linha** tem esse valor.
>
> Uma consequência interessante: se dois imóveis empatassem no preço mais alto,
> os dois apareceriam. O `MAX` devolve o valor, não a linha — então todas as
> linhas que batem com ele entram no resultado.

Criei também a versão com `MIN`, para o aluguel mais barato:

```sql
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
```

---

# 10. Subconsulta correlacionada

**Pergunta:**

> Quais imóveis custam acima da média do seu próprio tipo?

```sql
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
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna `i1.tipo`. É ela que torna a subconsulta **correlacionada**.
>
> A diferença em relação à subconsulta da seção 4 é profunda, mesmo que a
> escrita pareça parecida:
>
> - Na seção 4, a subconsulta é **independente**. Ela poderia ser executada
>   sozinha, roda uma única vez, e o resultado serve para todas as linhas.
> - Aqui, a subconsulta **não funciona sozinha** — se eu copiar só o trecho
>   interno e tentar rodar, o MySQL responde `Unknown column 'i1.tipo'`, porque
>   `i1` só existe no contexto da consulta externa.
>
> O funcionamento é linha a linha: para cada imóvel da consulta externa, o banco
> executa a subconsulta de novo, calculando a média daquele tipo específico. Com
> 8 imóveis, a subconsulta roda 8 vezes.
>
> **Por que isso importa para a pergunta:** comparar uma casa com a média geral
> da carteira não diz quase nada, porque essa média mistura terrenos de
> R$ 280.000 com kitnets de R$ 950. Comparar cada casa com a média das casas
> responde à pergunta real — "este imóvel é caro **para o que ele é**?".
>
> O preço disso é desempenho: a subconsulta correlacionada roda uma vez por
> linha. Com oito imóveis é instantâneo; com um milhão, seria um problema.

Criei uma segunda correlacionada, desta vez no `SELECT`:

```sql
SELECT
    i.titulo,
    i.bairro,
    i.preco,
    (SELECT COUNT(*)
     FROM visitas AS v
     WHERE v.id_imovel = i.id_imovel) AS total_visitas
FROM imoveis AS i
ORDER BY total_visitas DESC, i.preco DESC;
```

Aqui a subconsulta aparece como uma coluna do resultado, e também roda uma vez
para cada imóvel. Vantagem sobre o `LEFT JOIN` + `GROUP BY` da Sprint 1: os
imóveis sem visita aparecem naturalmente com `0`, sem precisar do cuidado com
`COUNT(coluna)` em vez de `COUNT(*)`.

---

# 11. Resolver a mesma pergunta de duas formas

## Pergunta 1

> Quais clientes já visitaram algum imóvel?

### JOIN

```sql
SELECT DISTINCT
    cl.nome,
    cl.telefone
FROM clientes AS cl
INNER JOIN visitas AS v
    ON cl.id_cliente = v.id_cliente
ORDER BY cl.nome;
```

### SUBQUERY

```sql
SELECT
    nome,
    telefone
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM visitas
)
ORDER BY nome;
```

### Qual abordagem ficou mais compreensível?

> A subconsulta, neste caso.
>
> O detalhe que decide é o `DISTINCT` na versão com `JOIN`. Ele é obrigatório ali,
> porque o cliente 1 realizou duas visitas e apareceria duplicado no resultado —
> o `JOIN` gera uma linha por par cliente-visita, não por cliente.
>
> A versão com `IN` não tem esse problema: ela filtra a tabela `clientes`, então
> cada cliente aparece no máximo uma vez, naturalmente. Nada de duplicação, nada
> de `DISTINCT`.
>
> Há também uma diferença de intenção. O `JOIN` combina tabelas para mostrar
> dados das duas; a subconsulta filtra uma tabela usando a outra como critério.
> Como aqui eu só quero dados de `clientes` — nome e telefone, nada de `visitas`
> — a subconsulta expressa melhor o que estou fazendo.
>
> O `JOIN` seria a escolha certa se eu precisasse mostrar também a data da
> visita, porque aí os dados das duas tabelas apareceriam no resultado.

---

## Pergunta 2

> Quais imóveis nunca receberam visita?

### JOIN

```sql
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
```

### SUBQUERY

```sql
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
```

### Comparação

> Aqui a subconsulta vence em clareza, mesmo produzindo o mesmo resultado.
>
> A versão com `JOIN` funciona por um caminho indireto: ela junta tudo, inclusive
> as linhas sem correspondência, e depois filtra as que ficaram nulas. Quem lê
> precisa entender que `WHERE v.id_visita IS NULL` significa "onde o `LEFT JOIN`
> não achou nada" — o que não é óbvio à primeira vista.
>
> A versão com `NOT EXISTS` diz literalmente o que quer: imóveis para os quais
> **não existe** visita. Lendo em voz alta, a consulta é a própria pergunta.
>
> Uma observação sobre desempenho, ao contrário do que eu esperava: o
> `NOT EXISTS` não é necessariamente mais lento por ser correlacionado. Como ele
> para na primeira correspondência encontrada, costuma ser eficiente, e o
> otimizador do MySQL frequentemente converte as duas formas no mesmo plano de
> execução. A escolha aqui é mais de legibilidade do que de performance.

---

# 13. Validação prática

Escolhi a subconsulta correlacionada:

```sql
SELECT
    i1.titulo,
    i1.tipo,
    i1.preco
FROM imoveis AS i1
WHERE i1.preco > (
    SELECT AVG(i2.preco)
    FROM imoveis AS i2
    WHERE i2.tipo = i1.tipo
);
```

**1. Qual consulta é executada primeiro?**

> Neste caso específico, a externa — e essa é a diferença crucial em relação a
> uma subconsulta comum.
>
> O banco começa percorrendo a tabela `imoveis` como `i1`. Para **cada linha**
> que encontra, ele executa a subconsulta usando o `tipo` daquela linha. Não há
> um "primeiro a interna, depois a externa": as duas se alternam, linha a linha.
>
> Em uma subconsulta independente (como a da seção 4), seria o contrário: a
> interna roda uma vez, antes de tudo, e o resultado fica guardado.

**2. Qual valor ou conjunto de valores ela retorna?**

> A cada execução, a subconsulta retorna um único número: a média de preço dos
> imóveis do mesmo tipo da linha que está sendo avaliada.
>
> Quando `i1` é uma casa, retorna a média das casas. Quando é um apartamento,
> retorna a média dos apartamentos. São valores diferentes a cada passagem.

**3. Como esse resultado é utilizado pela consulta externa?**

> O preço da linha atual é comparado com a média recém-calculada. Se for maior,
> a linha entra no resultado; se não, é descartada.
>
> Com 8 imóveis na tabela, a subconsulta é executada 8 vezes.

---

# 14. Teste operacional no Workbench

**Consulta original:**

```sql
SELECT titulo, tipo, preco
FROM imoveis
WHERE preco > 300000
ORDER BY preco DESC;
```

**Alteração realizada:**

> Troquei o filtro de `300000` para `1000000`.

**Mudança observada:**

> O resultado caiu de quatro imóveis para um. Com o filtro em R$ 300.000,
> apareciam a casa térrea, o sobrado, a casa nova e o terreno. Com
> R$ 1.000.000, restou apenas o sobrado alto padrão.
>
> Fiz um segundo teste mais interessante, na subconsulta de comparação: troquei
> `AVG` por `MIN` na consulta interna. O resultado saltou de dois imóveis para
> sete — porque praticamente todos custam mais que o mais barato da carteira.
> Isso deixou claro que a subconsulta é um valor dinâmico, e não um número fixo
> escrito na consulta: mudando a função de agregação, muda todo o conjunto de
> resposta.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| `Subquery returns more than 1 row` ao tentar comparar o preço com uma subconsulta | Usei `>` com uma subconsulta que devolvia vários preços, em vez de um valor agregado | Inclusão de `AVG()` na consulta interna, garantindo retorno de valor único; para listas, o operador correto é `IN` |
| A consulta de clientes que visitaram trazia o cliente 1 duas vezes na versão com `JOIN` | O cliente realizou duas visitas, e o `JOIN` gera uma linha por par cliente-visita | Uso de `DISTINCT` na versão com `JOIN`; a versão com `IN` não apresenta o problema, por filtrar a tabela `clientes` diretamente |
| `Unknown column 'i1.tipo' in where clause` ao testar a subconsulta correlacionada isoladamente | Tentei executar só o trecho interno para conferir o resultado, mas `i1` existe apenas no contexto da consulta externa | Compreendi que subconsulta correlacionada não roda sozinha; para conferir, substituí temporariamente `i1.tipo` por um valor fixo como `'Casa'` |
| Ao estudar o `NOT IN`, descobri que ele retorna resultado vazio se a subconsulta contiver `NULL` | Comportamento da lógica de três valores do SQL: comparação com `NULL` resulta em desconhecido, não em verdadeiro | No meu banco não ocorre, porque as colunas de FK são `NOT NULL`; registrei a limitação e passei a preferir `NOT EXISTS` para perguntas sobre ausência |

---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei subconsulta com comparação;
- [x] utilizei `IN`;
- [x] utilizei `NOT IN`;
- [x] utilizei `EXISTS`;
- [x] utilizei `NOT EXISTS`;
- [x] utilizei `MAX` ou `MIN`;
- [x] criei subconsulta correlacionada;
- [x] resolvi duas perguntas usando JOIN e SUBQUERY;
- [x] expliquei o raciocínio;
- [x] testei no MySQL Workbench;
- [x] consigo explicar as consultas presencialmente;
- [x] salvei `SPRINT2-5.md`;
- [x] salvei `SPRINT2-5.sql`.
