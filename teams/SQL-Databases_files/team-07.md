# Team 07 — Módulo de salas

## Integrantes

- Marcos Stanguerlin

---

# Descrição
Tabela MySQL criada para identificação de salas e seus materiais principais

---

# CREATE TABLE

```sql
CREATE TABLE SigaaID (
    IdSala INT AUTO_INCREMENT PRIMARY KEY NOT NULL
);


CREATE TABLE SigaaTipoSala (
    TipoSalaID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    TipoSala VARCHAR(25)
);

CREATE TABLE SigaaHorario (
    HorarioDeUso INT AUTO_INCREMENT PRIMARY KEY,
    
    FOREIGN KEY (TipoSalaID)
        REFERENCES SigaaTipoSala(TipoSalaID)
);

CREATE TABLE SigaaMateriais (
    MaterialID INT AUTO_INCREMENT PRIMARY KEY,
    IdSala INT,
    Materiais VARCHAR(25),
    QtdMateriais INT NOT NULL,
    MatPrincipal BOOLEAN,
	
    FOREIGN KEY (IdSala)
        REFERENCES SigaaID(IdSala)
);

CREATE TABLE SigaaSalas (
    IdSala INT PRIMARY KEY AUTO_INCREMENT,

    TipoSalaID INT,
    HorarioDeUso INT,
    MateriaisID INT,

    FOREIGN KEY (TipoSalaID)
        REFERENCES SigaaTipoSala(TipoSalaID),

    FOREIGN KEY (HorarioDeUso)
        REFERENCES SigaaHorario(HorarioDeUso),

	FOREIGN KEY (MateriaisID)
		REFERENCES SigaaMateriais(MaterialID)
);
```

---

# INSERT INTO

```sql
INSERT INTO SigaaMateriais (Materiais)
VALUES
('Cadeira'),
('Mesas'),
('Projetores'),
('Canetão'),
('Computadores');

INSERT INTO SigaaTipoSala (TipoSala)
VALUES
('Banheiro'),
('Sala de estudo'),
('Sala de computadores'),
('Sala de Reunião'),
('Sala da limpeza'),
('Sala RH');
```

---

# CONSULTAS SQL

## SELECT *

```sql
SELECT
    s.IdSala,
    ts.TipoSala AS TipoSalas,
    h.HorarioDeUso,
    m.Materiais AS MatPrincipal,
    m.QtdMateriais

FROM SigaaSalas s

JOIN SigaaTipoSala ts
    ON s.TipoSalaID = ts.TipoSalaID

JOIN SigaaHorario h
    ON s.HorarioDeUso = h.HorarioDeUso

JOIN SigaaMateriais m
    ON s.MateriaisID = m.MaterialID

WHERE m.MatPrincipal = TRUE;
```
---

# JOIN

```sql
SELECT *
FROM example;
```

---

# Screenshots

```
Devido ao MySQL não estar funcionando servidores nos computadores da unemat, não consigo realizar screenshots do código em prática
```
