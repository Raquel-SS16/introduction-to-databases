# SPRINT 1/5 — Planejamento do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados  
**Data:** 01/09/2026  
**Modalidade:** Atividade individual  

---

# Objetivo da Sprint 1/5

Nesta primeira etapa, cada aluno deverá **planejar individualmente um banco de dados completo**, que será desenvolvido de forma incremental ao longo das cinco Sprints.

O banco escolhido nesta Sprint será o mesmo utilizado nas próximas etapas da atividade.

Ao final da semana, cada aluno deverá possuir um banco de dados funcional contendo:

- estrutura de tabelas;
- chaves primárias;
- chaves estrangeiras;
- restrições de integridade;
- dados cadastrados;
- operações de inserção, alteração e exclusão;
- consultas SQL;
- funções de agregação;
- agrupamentos;
- validação e documentação final.

Nesta Sprint 1/5, o foco é exclusivamente o **planejamento do banco de dados**.

> **Importante:** ainda não é necessário implementar o banco em SQL. A implementação começará na Sprint 2/5.

---

# 1. Identificação do aluno

**Nome completo:**

> Raquel Silva Dos Santos.

**Nome escolhido para o banco de dados:**

```

```

---

# 2. Tema do banco de dados

Escolha um domínio para o banco de dados que será desenvolvido durante toda a atividade.

O tema é livre, desde que permita a criação de um banco relacional com múltiplas tabelas e relacionamentos coerentes.

Alguns exemplos:

- sistema acadêmico;
- biblioteca;
- clínica;
- loja;
- restaurante;
- academia;
- hotel;
- oficina;
- locadora;
- e-commerce;
- sistema de eventos;
- sistema de transporte;
- imobiliária;
- pet shop;
- escola;
- campeonato esportivo;
- outro domínio de interesse do aluno.

### Tema escolhido

> Biblioteca.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> O sistema é uma biblioteca online de livros digitais (estilo Kindle). Ele serve para liberar e controlar o acesso temporário aos e-books, garantindo que o leitor só acerte a leitura pelo tempo permitido do empréstimo.
>
> Quem usa

Leitores: navegam pelo acervo, pegam livros digitais emprestados e leem nos seus aparelhos.

Administrador: cadastra novos e-books no catálogo e gerencia os acessos dos usuários

>O que precisa ser guardado

Usuários: nome, e-mail, senha e tipo de conta.

Livros digitais: título, autor, gênero e o link/arquivo do e-book.

Empréstimos: quem pegou o livro, quando pegou e a data em que o acesso expira.

Aparelhos: os dispositivos (celular, tablet ou leitor digital) conectados na conta do usuário.

>O que o sistema faz

Cadastra, edita e remove livros e usuários.

Permite pesquisar livros por título, autor ou categoria.

Libera o livro digital por um período de dias determinado.

Bloqueia o acesso ao livro assim que o prazo termina.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> O principal objetivo do banco de dados é gerenciar o acervo de e-books e controlar o acesso temporário dos leitores a esses livros. Ele serve para organizar o catálogo digital, registrar quem pegou qual título e garantir que a permissão de leitura funcione apenas durante o prazo do empréstimo.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar e manter os dados dos usuários (nome, e-mail, senha e tipo de plano).
2. Cadastrar e organizar o catálogo de e-books com autor, título, categoria e arquivo digital.
3. Registrar o empréstimo de um livro para o usuário, definindo a data de início e a data final de acesso.
4. Controlar o prazo de expiração para revogar a permissão de leitura quando o tempo acabar.
5. Associar os aparelhos de leitura (e-reader, celular, tablet) à conta de cada leitor.

---

# 6. Identificação das entidades

Identifique as principais entidades necessárias para representar o sistema.

Uma entidade representa algo sobre o qual o banco precisa armazenar informações.

Exemplos:

```text
Aluno
Curso
Matrícula
Professor
Disciplina
```

ou:

```text
Livro
Exemplar
Usuario
Emprestimo
Autor
Categoria
```

### Entidades do seu banco


| Nº | Entidade | O que representa? |
|---:|---|---|
| 1 | Usuario | Representa os leitores cadastrados que realizam os empréstimos. |
| 2 | Livro_digital | Os e-books disponíveis no acervo para leitura (título, autor, ISBN, ano de publicação). |
| 3 | Categoria | Representa o gênero ou classificação temática do livro (ex.: Ficção, Fantasia, História). |
| 4 | Emprestimo | O registro do livro liberado temporariamente para o leitor com prazo de expiração. |
| 5 | Dispositivo | Os aparelhos (Kindle, celular, tablet) conectados à conta do usuário. |

> 

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:** 

```text

USUÁRIO

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_usuário | Identificador único do usuário (chave primária) | INT | Sim |
| Nome | Nome completo do leitor | VARCHAR(50) | Sim  |
| Plano | Tipo de assinatura (ex.: Grátis, Premium) | VARCHAR (20)  | Sim  |
| E-mail | E-mail para contato e avisos de devolução  |VARCHAR (50)  | Sim |
| Senha | Senha de acesso | VARCHAR (50) | Sim |

## Entidade 2

**Nome da entidade:**

```text
LIVRO DIGITAL

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_livro |Código único do e-book | INT |Sim |
| Título | Nome do livro | VARCHAR(50) | Sim |
| Autor | Nome do(s) autor(es) da obra | VARCHAR(50) | Sim |
| link_arquivo| Endereço do arquivo digital | VARCHAR(50) | Sim |
| Id_categoria | Código da categoria do livro| INT | Sim |

## Entidade 3

**Nome da entidade:**

```text

CATEGORIA

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_categoria  | Código único da categoria | INT | Sim |
| Nome | Nome do gênero literário | VARCHAR(20) | Sim |
| Descricao | Breve explicação sobre a categoria | VARCHAR(200) | Não |


## Entidade 4

**Nome da entidade:**

```text

EMPRESTIMO

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_emprestimo | Código único do empréstimo | INT | Sim |
| Id_usuário | Código do usuário que pegou o livro | INT | Sim |
| Id_livro | Código do livro emprestado | INT | Sim |
| Data_inicio | Data e hora em que liberou o acesso | DATETIME | Sim |
| Data_fim | Data e hora em que expira o acesso | DATETIME | Sim |
| Status | Situação atual (Ativo, Expirado, Devolvido) | VARCHAR(20) | Sim |


## Entidade 5


**Nome da entidade:**

```text

DISPOSITIVO

```
| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_dispositivo | Código único de controle no banco de dados | INT | Sim |
| Id_usuário | Código do usuário dono do aparelho | INT | Sim |
| Tipo | Modelo do aparelho (Kindle, Celular, Tablet) |VARCHAR(50) | Sim |
| Id_aparelho | Identificador único do aparelho | VARCHAR (20) | Sim |



---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| Usuário | Id_usuario | Identificador numérico inteiro com AUTO_INCREMENT. Garante que cada leitor tenha um código exclusivo no sistema, evitando problemas caso existam pessoas com o mesmo nome ou caso o usuário precise alterar seu e-mail. Nunca se repete. |
| Livro Digital | Id_livro | Identificador numérico inteiro com AUTO_INCREMENT. Cada e-book cadastrado recebe um código único e imutável, permitindo diferenciar edições ou arquivos com facilidade e sem depender do título, que pode se repetir. |
| Categoria | Id_categoria | Identificador numérico inteiro com AUTO_INCREMENT. Garante unicidade para cada gênero literário (Suspense, Ficção, Romance), facilitando a criação de filtros e pesquisas rápidas sem risco de duplicidade de registros. |
| Emprestimo | Id_emprestimo | Identificador numérico inteiro com AUTO_INCREMENT. Como o mesmo leitor pode pegar o mesmo livro mais de uma vez ao longo do tempo, um identificador próprio e sequencial é essencial para registrar cada transação de acesso de forma isolada e única. |
| Dispositivo | Id_dispositivo | Identificador numérico inteiro com AUTO_INCREMENT. Permite que um mesmo usuário tenha vários aparelhos cadastrados (ex.: um Kindle e dois celulares) sem conflito, identificando cada aparelho de forma exclusiva. |

Considere:

- o valor identifica cada registro de forma única?
- o valor poderá se repetir?
- será utilizado um identificador numérico?
- será necessário `AUTO_INCREMENT`?

---

# 9. Relacionamentos entre as entidades

Identifique como as entidades se relacionam.

### Exemplo

```text
Cliente realiza Pedido
Pedido possui Item_Pedido
Produto aparece em Item_Pedido
```

### Relacionamentos planejados

| Entidade A | Relacionamento | Entidade B |
|---|---|---|
| Categoria | classifica | Livro Digital |
| Usuario | realiza | Emprestimo |
| Livro_Digital | disponibilizado em | Emprestimo |
| Usuario | vincula | Dispositivo |
|  |  |  |

---

# 10. Cardinalidade inicial

Utilize:

```text
1:1  → um para um
1:N  → um para muitos
N:N  → muitos para muitos
```

| Relacionamento | Cardinalidade prevista | Justificativa |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |

> As `FOREIGN KEY` serão implementadas posteriormente. Nesta Sprint, apenas planeje os relacionamentos.

---

# 12. Restrições de integridade previstas

Podem ser consideradas:

```sql
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
DEFAULT
AUTO_INCREMENT
```

| Tabela | Atributo | Restrição prevista | Motivo |
|---|---|---|---|
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

---

# 13. Regras de negócio

Defina pelo menos **5 regras de negócio** para o sistema.

### Exemplos

```text
Um cliente não pode possuir dois cadastros com o mesmo CPF.
Um pedido deve estar associado a um cliente existente.
Um produto não pode possuir preço negativo.
Uma matrícula deve estar associada a um aluno e a uma disciplina.
Um empréstimo deve possuir uma data de realização.
```

### Regras do seu banco

1. 
2. 
3. 
4. 
5. 

---

# 14. Esboço da estrutura do banco

Faça uma representação textual inicial das tabelas e relacionamentos.

### Exemplo

```text
CLIENTE
├── id_cliente (PK)
├── nome
└── email

PEDIDO
├── id_pedido (PK)
├── id_cliente (FK)
└── data_pedido

CLIENTE 1 ───── N PEDIDO
```

### Esboço do seu banco

```text
Escreva aqui a estrutura planejada.
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. 
2. 
3. 
4. 

---

# 16. Perguntas que o banco deverá ser capaz de responder

Defina pelo menos **5 perguntas** que futuramente deverão ser respondidas por consultas SQL.

### Exemplos

```text
Quais clientes estão cadastrados?
Quais produtos custam mais de R$ 100?
Quantos pedidos foram realizados por cliente?
Qual é o valor médio dos produtos?
Quais categorias possuem mais de 5 produtos?
```

### Perguntas do seu projeto

1. 
2. 
3. 
4. 
5. 

---

# 17. Decisões e dúvidas pendentes

- 
- 
- 

Caso não existam dúvidas:

> Nenhuma dúvida pendente nesta Sprint.

---

# 18. Checklist da Sprint 1/5

- [ ] identifiquei o aluno responsável;
- [ ] defini o tema do banco de dados;
- [ ] descrevi o sistema;
- [ ] defini o objetivo do banco;
- [ ] defini o escopo inicial;
- [ ] identifiquei pelo menos 4 entidades;
- [ ] planejei os principais atributos;
- [ ] defini as chaves primárias previstas;
- [ ] identifiquei os relacionamentos;
- [ ] defini as cardinalidades iniciais;
- [ ] identifiquei possíveis chaves estrangeiras;
- [ ] planejei restrições de integridade;
- [ ] defini pelo menos 5 regras de negócio;
- [ ] fiz um esboço da estrutura do banco;
- [ ] defini os tipos de dados que futuramente serão cadastrados;
- [ ] defini pelo menos 5 perguntas que o banco deverá responder;
- [ ] registrei dúvidas ou decisões pendentes;
- [ ] revisei o arquivo antes de finalizar.

---

# Entrega da Sprint 1/5

O arquivo desta etapa deverá ser salvo com o nome:

```text
SPRINT1-5.md
```

O aluno deverá manter este arquivo, pois ele será utilizado como referência para as próximas Sprints.

A evolução será:

```text
SPRINT1-5.md
    ↓
Planejamento do banco
    ↓
SPRINT2-5.md
    ↓
Criação da estrutura com DDL
    ↓
SPRINT3-5.md
    ↓
Inserção e manipulação de dados
    ↓
SPRINT4-5.md
    ↓
Consultas SQL
    ↓
SPRINT5-5.md
    ↓
Validação e entrega do banco completo
```

---

# Regras de Git/GitHub

A atividade é **individual**.

Cada aluno deverá manter seu próprio histórico de desenvolvimento durante as cinco Sprints.

## Branch

O aluno deverá trabalhar em uma branch própria durante toda a atividade.

A branch não deverá ser recriada a cada Sprint.

Utilize a convenção definida pelo professor para identificação individual.

> A convenção definitiva do nome da branch deverá ser compatível com a validação automática do repositório.

## Commit

Cada Sprint deverá gerar pelo menos um commit próprio.

Mensagem sugerida para hoje:

```text
Conclui Sprint 1 de 5 - planejamento do banco
```

Nas próximas etapas:

```text
Conclui Sprint 2 de 5 - estrutura DDL
Conclui Sprint 3 de 5 - operações DML
Conclui Sprint 4 de 5 - consultas SQL
Conclui Sprint 5 de 5 - validação final
```

## Pull Request

**Não abrir o Pull Request final nesta Sprint.**

O Pull Request será realizado somente após a conclusão da Sprint 5/5.

```text
SPRINT1-5.md → commit
SPRINT2-5.md → commit
SPRINT3-5.md → commit
SPRINT4-5.md → commit
SPRINT5-5.md → commit
                         ↓
                  Pull Request final
                         ↓
                        main
```

---

# Critério de conclusão da Sprint 1/5

A Sprint será considerada concluída quando o aluno apresentar um planejamento suficientemente detalhado para permitir que, na próxima etapa, consiga transformar sua proposta em um banco de dados relacional utilizando SQL.

Não basta informar apenas o tema.

O planejamento deverá demonstrar:

- quais tabelas existirão;
- quais informações serão armazenadas;
- como as tabelas se relacionarão;
- quais regras deverão ser respeitadas;
- quais consultas o banco deverá permitir ao final da atividade.

---

# Próxima etapa

Na **Sprint 2/5**, o planejamento será transformado em uma implementação utilizando comandos DDL.

Serão trabalhados:

```sql
CREATE DATABASE
CREATE TABLE
ALTER TABLE
DROP TABLE
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
DEFAULT
```

> **Não implemente a Sprint 2/5 neste arquivo.**
