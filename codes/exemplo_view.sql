CREATE DATABASE exemplo_view;
USE exemplo_view;


-- Esquema do banco de dados

CREATE TABLE departamento (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL
);

CREATE TABLE funcionario (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  salario_base DECIMAL(10, 2) NOT NULL,
  departamento_id INT NOT NULL,
  CONSTRAINT fk_fun_dep FOREIGN KEY (departamento_id)
    REFERENCES departamento (id)
);

CREATE TABLE projeto (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  orcamento DECIMAL(10, 2) NOT NULL
);

CREATE TABLE trabalha_em (
  funcionario_id INT NOT NULL,
  projeto_id INT NOT NULL,
  carga_horaria INT,
  retribuicao DECIMAL(10, 2),
  CONSTRAINT PRIMARY KEY (funcionario_id, projeto_id),
  CONSTRAINT fk_fun_trab FOREIGN KEY (funcionario_id)
    REFERENCES funcionario (id),
  CONSTRAINT fk_pro_trab FOREIGN KEY (projeto_id)
    REFERENCES departamento (id)
);


-- Carga de dados

INSERT INTO departamento (nome) VALUES 
  ('RH'),
  ('Financeiro'),
  ('Administrativo'),
  ('Serviços Gerais'),
  ('Projeto');
  
INSERT INTO funcionario (nome, salario_base, departamento_id) VALUES 
  ('Leonardo', 5000, 2),
  ('Fred', 10000, 3),
  ('Thomás', 11000, 1),
  ('Jorge', 6000, 5),
  ('Daniel', 9000, 5),
  ('João Victor', 4000, 4),
  ('Júlia', 20000, 5),
  ('Lucas', 8000, 5),
  ('Israel', 5000, 2);
  
INSERT INTO projeto (nome, orcamento) VALUES 
  ('Ctrl+C Ctrl+V remoto', 20000), 
  ('Rotativo Digital', 50000),
  ('Resolver NP-Completo', 1000000),
  ('SIGAA Decente', 300000),
  ('Agregador de jogos digitais', 90000);
  
INSERT INTO trabalha_em (funcionario_id, projeto_id, carga_horaria, retribuicao) VALUES 
  (1, 1, 3, 1977), 
  (2, 2, 4, 3000),
  (3, 3, 7, 550),
  (4, 4, 1, 600),
  (5, 5, 1, 788),
  (6, 5, 8, 2030),
  (7, 4, 3, 2000),
  (8, 3, 5, 1050),
  (9, 2, 6, 500),
  (1, 2, 2, 2900),
  (3, 5, 2, 1800),
  (6, 2, 1, 690),
  (9, 1, 3, 700),
  (1, 3, 7, 2600),
  (1, 5, 4, 2356);
  
  
-- Consultas
SELECT
  id,
  nome,
  orcamento,
  IF(orcamento <= 100000, 'Pequeno', 'Grande') AS classe
FROM projeto;

CREATE VIEW vw_classificacao_projetos AS
SELECT
  id,
  nome,
  orcamento,
  IF(orcamento <= 100000, 'Pequeno', 'Grande') AS classe
FROM projeto;

SHOW TABLES;

SELECT * FROM vw_classificacao_projetos;

UPDATE projeto
  SET orcamento = 600000
  WHERE id = 1;
  
SELECT * FROM vw_classificacao_projetos;

SELECT * FROM
  (SELECT id, nome, orcamento,
   IF(orcamento <= 100000, 'Pequeno', 'Grande') AS classe
   FROM projeto) AS vw_classificacao_projetos;
   
SELECT * FROM vw_classificacao_projetos;

UPDATE vw_classificacao_projetos
  SET orcamento = 500000
  WHERE id = 4;
  
SELECT * FROM vw_classificacao_projetos;

SELECT * FROM projeto;

CREATE VIEW vw_atribuicoes AS
SELECT 
  f.id AS funcionario_id, f.nome AS funcionario_nome , 
  p.id AS projeto_id, p.nome AS projeto_nome,
  t.carga_horaria AS carga_horaria,
  t.retribuicao AS retribuicao
FROM funcionario AS f
  LEFT OUTER JOIN trabalha_em AS t ON f.id = t.funcionario_id
  LEFT OUTER JOIN projeto AS p ON t.projeto_id = p.id;
  
SHOW TABLES;
SELECT * FROM vw_atribuicoes;

CREATE VIEW vw_folha_pagamento AS
SELECT 
  f.id,
  f.nome,
  f.salario_base,
  SUM(t.retribuicao) AS soma_retribuicoes
FROM funcionario AS f
  LEFT OUTER JOIN trabalha_em AS t ON f.id = t.funcionario_id
  LEFT OUTER JOIN projeto AS p ON t.projeto_id = p.id
GROUP BY f.id;

SELECT * FROM vw_folha_pagamento;
