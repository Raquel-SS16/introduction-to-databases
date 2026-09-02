nome
# Team 11 — Módulo Financeiro

## Integrantes

- Nome 1 PAULO CESAR NASCIMENTO
- 

---

# Descrição

MODULO 11 FINANCEIRO

---

# CREATE TABLE

CREATE TABLE pagamentos (
    idaluno INT NOT NULL,
    data_pagamento DATE,
    valor double,
    idbolsa_aluno VARCHAR(45) NOT NULL,
    idcontapagamento INT NOT NULL,
    agenciabanco INT,
    historico VARCHAR(80),
    PRIMARY KEY (idaluno, idbolsa_aluno, idcontapagamento)
);
```

---

# INSERT INTO
INSERT INTO pagamentos (idaluno, data_pagamento, valor, idbolsa_aluno, idcontapagamento, agenciabanco, historico) 
VALUES 
(1, '2026-05-01', 550.00, 'B-Integral', 101, 3456, 'Mensalidade Maio - Paga em dia'),
(2, '2026-05-15', 275.50, 'B-Parcial', 102, 1234, 'Mensalidade Maio - Com atraso');

---

# CONSULTAS SQL

SELECT * FROM pagamentos WHERE data_pagamento BETWEEN '2026-05-01' AND '2026-05-31';
SELECT * FROM example;
```

---

## SELECT COM WHERE

```sql
SELECT idaluno, data_pagamento, valor 
FROM pagamentos 
WHERE valor > 500.00;
```

---

## SELECT COM ORDER BY

```sql
-- Consulta de todos os pagamentos ordenados da data mais recente para a mais antiga
SELECT * FROM pagamentos 
ORDER BY data_pagamento DESC;
```

---

# JOIN

```sql
SELECT a.nome, p.data_pagamento, p.valor 
FROM alunos a
INNER JOIN pagamentos p ON a.idaluno = p.idaluno;
```

---

# Screenshots
<img width="278" height="276" alt="186c6f7a-32b4-432a-871d-81d0b8c265ed" src="https://github.com/user-attachments/assets/afcb5ed8-ab65-4e8c-b1a7-483357ea22de" />

Inserir screenshots do MySQL Workbench abaixo.
