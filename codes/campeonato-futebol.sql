-- ------------------------------------------------------------------
-- Banco de dados

CREATE DATABASE campeonato;
USE campeonato;


-- ------------------------------------------------------------------
-- Definição do esquema do banco de dados

CREATE TABLE equipe (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(64) NOT NULL,
  cidade VARCHAR(32) NOT NULL,
  estado CHAR(2) NOT NULL,
  treinador VARCHAR(64) NOT NULL
);

CREATE TABLE estadio (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(32) NOT NULL,
  estado CHAR(2) NOT NULL,
  capacidade INTEGER NOT NULL
);

CREATE TABLE partida (
  mandante INTEGER,
  visitante INTEGER,
  data_hora DATETIME NOT NULL,
  gols_mandante INTEGER,
  gols_visitante INTEGER,
  estadio INTEGER NOT NULL,
  CONSTRAINT PRIMARY KEY (mandante, visitante),
  CONSTRAINT FOREIGN KEY (mandante) REFERENCES equipe (id),
  CONSTRAINT FOREIGN KEY (visitante) REFERENCES equipe (id),
  CONSTRAINT FOREIGN KEY (estadio) REFERENCES estadio (id)
);

-- ------------------------------------------------------------------
-- Carga de dados

-- Equipes
INSERT INTO equipe (id, nome, cidade, estado, treinador) VALUES 
  (1, 'Atlético-MG', 'Belo Horizonte', 'MG', 'Cuca'), 
  (2, 'Palmeiras', 'São Paulo', 'SP', 'Abel Ferreira'), 
  (3, 'Flamengo', 'Rio de Janeiro', 'RJ', 'Renato Gaúcho'), 
  (4, 'Bragantino', 'Bragança Paulista', 'SP', 'Maurício Barbieri');
  
-- Estádios
INSERT INTO estadio (id, nome, estado, capacidade) VALUES 
  (1, 'Mineirão', 'MG', 61846),
  (2, 'Allianz Parque', 'SP', 43713),
  (3, 'Maracanã', 'RJ', 78838),
  (4, 'Nabi Abi Chedid', 'SP', 12332);

-- Partidas (antes dos jogos)
INSERT INTO partida (mandante, visitante, estadio, data_hora) VALUES 
  (3, 2, 3, '2021-05-30 16:00:00'),  
  (3, 4, 3, '2021-06-19 21:00:00'), 
  (4, 2, 4, '2021-06-23 19:00:00'), 
  (1, 3, 1, '2021-07-07 19:00:00'), 
  (1, 2, 1, '2021-08-14 19:00:00'), 
  (4, 1, 4, '2021-08-29 20:30:00'), 
  (2, 3, 2, '2021-09-12 16:00:00'),  
  (4, 3, 4, '2021-10-06 20:30:00'), 
  (2, 4, 2, '2021-10-09 21:00:00'), 
  (3, 1, 3, '2021-10-30 19:00:00'), 
  (2, 1, 2, '2021-11-24 19:00:00'), 
  (1, 4, 1, '2021-12-01 19:00:00');
  
-- Atualização de placares de jogos ocorridos
UPDATE partida
SET gols_mandante = 1, gols_visitante = 0
WHERE mandante = 3 AND visitante = 2;

UPDATE partida
SET gols_mandante = 2, gols_visitante = 3
WHERE mandante = 3 AND visitante = 4;

UPDATE partida
SET gols_mandante = 3, gols_visitante = 1
WHERE mandante = 4 AND visitante = 2;

UPDATE partida
SET gols_mandante = 2, gols_visitante = 1
WHERE mandante = 1 AND visitante = 3;

UPDATE partida
SET gols_mandante = 2, gols_visitante = 0
WHERE mandante = 1 AND visitante = 2;

UPDATE partida
SET gols_mandante = 1, gols_visitante = 1
WHERE mandante = 4 AND visitante = 1;

UPDATE partida
SET gols_mandante = 1, gols_visitante = 3
WHERE mandante = 2 AND visitante = 3;

UPDATE partida
SET gols_mandante = 1, gols_visitante = 1
WHERE mandante = 4 AND visitante = 3;

UPDATE partida
SET gols_mandante = 2, gols_visitante = 4
WHERE mandante = 2 AND visitante = 4;

UPDATE partida
SET gols_mandante = 1, gols_visitante = 0
WHERE mandante = 3 AND visitante = 1;


-- ------------------------------------------------------------------
-- Consultas

-- Placares dos jogos já realizados
SELECT
   p.data_hora AS 'data_hora',
   em.nome AS 'mandante',
   p.gols_mandante AS 'gols_mandante',
   ev.nome AS 'visitante',
   p.gols_visitante AS 'gols_visitante',
	e.nome AS 'estadio',
   e.estado AS 'estado'
FROM partida AS p
   INNER JOIN equipe AS em ON p.mandante = em.id
   INNER JOIN equipe AS ev ON p.visitante = ev.id
   INNER JOIN estadio AS e ON p.estadio = e.id
WHERE
   p.gols_mandante IS NOT NULL 
   AND p.gols_visitante IS NOT NULL 
ORDER BY p.data_hora DESC;


-- Jogos ainda não realizados
SELECT
   p.data_hora AS 'data_hora',
   em.nome AS 'mandante',
   ev.nome AS 'visitante',
   e.nome AS 'estadio',
   e.estado AS 'estado'
FROM partida AS p
   INNER JOIN equipe AS em ON p.mandante = em.id
   INNER JOIN equipe AS ev ON p.visitante = ev.id
   INNER JOIN estadio AS e ON p.estadio = e.id
WHERE
   p.gols_mandante IS NULL 
   AND p.gols_visitante IS NULL 
ORDER BY p.data_hora ASC;


-- Tabela do campeonato

SELECT 
  id,
  nome,
  SUM(vitorias) * 3 + SUM(empates) AS 'pontos',
  SUM(vitorias) AS 'vitorias',
  SUM(empates) AS 'empates',
  SUM(derrotas) AS 'derrotas',
  SUM(gols_pro) AS 'gols_pro',
  SUM(gols_contra) AS 'gols_contra',
  SUM(gols_pro) - SUM(gols_contra) AS 'saldo'
  
FROM

	((SELECT
	   e.id AS 'id',
	   e.nome AS 'nome',
	   COUNT(IF(p.gols_mandante > p.gols_visitante, 1, NULL)) AS 'vitorias',
	   COUNT(IF(p.gols_mandante < p.gols_visitante, 1, NULL)) AS 'derrotas',
	   COUNT(IF(p.gols_mandante = p.gols_visitante, 1, NULL)) AS 'empates',
	   SUM(p.gols_mandante) AS 'gols_pro',
	   SUM(p.gols_visitante) AS 'gols_contra'
	FROM equipe AS e
	   INNER JOIN partida AS p ON e.id = p.mandante
	WHERE
	   p.gols_mandante IS NOT NULL AND p.gols_visitante IS NOT NULL 
	GROUP BY e.id)

	UNION ALL 

	(SELECT
	   e.id AS 'id',
	   e.nome AS 'nome',
	   COUNT(IF(p.gols_mandante < p.gols_visitante, 1, NULL)) AS 'vitorias',
	   COUNT(IF(p.gols_mandante > p.gols_visitante, 1, NULL)) AS 'derrotas',
	   COUNT(IF(p.gols_mandante = p.gols_visitante, 1, NULL)) AS 'empates',
	   SUM(p.gols_mandante) AS 'gols_pro',
	   SUM(p.gols_visitante) AS 'gols_contra'
	FROM equipe AS e
	   INNER JOIN partida AS p ON e.id = p.visitante
	WHERE
	   p.gols_mandante IS NOT NULL AND p.gols_visitante IS NOT NULL 
	GROUP BY e.id)) AS tmp

GROUP BY id
ORDER BY pontos DESC, vitorias DESC, saldo DESC;


-- ------------------------------------------------------------------
-- Views

-- Cria uma view 'tabela' para consultar a tabela do campeonato

CREATE VIEW tabela
AS
SELECT 
  id,
  nome,
  SUM(vitorias) * 3 + SUM(empates) AS 'pontos',
  SUM(vitorias) AS 'vitorias',
  SUM(empates) AS 'empates',
  SUM(derrotas) AS 'derrotas',
  SUM(gols_pro) AS 'gols_pro',
  SUM(gols_contra) AS 'gols_contra',
  SUM(gols_pro) - SUM(gols_contra) AS 'saldo'
  
FROM

	((SELECT
	   e.id AS 'id',
	   e.nome AS 'nome',
	   COUNT(IF(p.gols_mandante > p.gols_visitante, 1, NULL)) AS 'vitorias',
	   COUNT(IF(p.gols_mandante < p.gols_visitante, 1, NULL)) AS 'derrotas',
	   COUNT(IF(p.gols_mandante = p.gols_visitante, 1, NULL)) AS 'empates',
	   SUM(p.gols_mandante) AS 'gols_pro',
	   SUM(p.gols_visitante) AS 'gols_contra'
	FROM equipe AS e
	   INNER JOIN partida AS p ON e.id = p.mandante
	WHERE
	   p.gols_mandante IS NOT NULL AND p.gols_visitante IS NOT NULL 
	GROUP BY e.id)

	UNION ALL 

	(SELECT
	   e.id AS 'id',
	   e.nome AS 'nome',
	   COUNT(IF(p.gols_mandante < p.gols_visitante, 1, NULL)) AS 'vitorias',
	   COUNT(IF(p.gols_mandante > p.gols_visitante, 1, NULL)) AS 'derrotas',
	   COUNT(IF(p.gols_mandante = p.gols_visitante, 1, NULL)) AS 'empates',
	   SUM(p.gols_mandante) AS 'gols_pro',
	   SUM(p.gols_visitante) AS 'gols_contra'
	FROM equipe AS e
	   INNER JOIN partida AS p ON e.id = p.visitante
	WHERE
	   p.gols_mandante IS NOT NULL AND p.gols_visitante IS NOT NULL 
	GROUP BY e.id)) AS tmp

GROUP BY id
ORDER BY pontos DESC, vitorias DESC, saldo DESC;


-- Exibe os dados da view
SELECT * FROM tabela;