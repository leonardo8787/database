USE empresa;

SELECT * FROM Funcionario;

SELECT 
	f.id, f.sobrenome, f.salario, COUNT(d.id) as num_dependentes,
	f.salario + COUNT(d.id) * 100 AS salario_total
FROM Funcionario AS f left OUTER JOIN Dependente AS d
ON f.id = d.id_fun 
GROUP BY f.id;

SELECT d.id, d.nome, SUM(f.salario_total) AS folha, MIN(f.salario_total) AS menor, MAX(f.salario_total) AS maior
FROM Departamento AS d
	LEFT OUTER JOIN 
		(SELECT f.id, f.id_dept, f.salario + COUNT(d.id) * 100 AS salario_total
		FROM Funcionario AS f LEFT OUTER JOIN Dependente AS d ON f.id = d.id_fun
		GROUP BY f.id) AS f 
	ON d.id = f.id_dept
GROUP BY d.id;

ALTER TABLE Funcionario
	ADD COLUMN email VARCHAR(50) UNIQUE;

SELECT * FROM Funcionario;

ALTER TABLE Funcionario 
	ADD COLUMN telefone VARCHAR(15) 
	AFTER id_dept;

SELECT * FROM Funcionario;

ALTER TABLE Funcionario 
	ADD COLUMN foo VARCHAR(10),
	add column bar INTEGER;

ALTER TABLE Funcionario 
	DROP COLUMN foo,
	DROP COLUMN bar;

SELECT * FROM Funcionario;

ALTER TABLE Funcionario 
	RENAME COLUMN nome TO primeiro_nome,
	RENAME COLUMN sobrenome TO ultimo_nome;

SELECT * FROM Funcionario;

SHOW CREATE TABLE Funcionario;

ALTER TABLE Funcionario 
	MODIFY COLUMN primeiro_nome VARCHAR(64) NOT NULL,
	MODIFY COLUMN ultimo_nome VARCHAR(50);

SHOW CREATE TABLE Funcionario;

ALTER TABLE Dependente 
	MODIFY COLUMN id INTEGER NOT NULL;

SHOW CREATE TABLE Dependente;

ALTER TABLE Dependente 
	DROP PRIMARY KEY;

ALTER TABLE Dependente 
	ADD CONSTRAINT PRIMARY KEY (id);

SELECT * FROM Dependente;

SHOW CREATE TABLE Dependente;

ALTER TABLE Dependente 
	DROP FOREIGN KEY dependente_ibfk_1;

SHOW CREATE TABLE Dependente;

ALTER TABLE Dependente 
	ADD CONSTRAINT fk_id_fun
	FOREIGN KEY (id_fun) REFERENCES Funcionario (id);

SHOW CREATE TABLE Dependente;

SHOW INDEX FROM Dependente;

ALTER TABLE Funcionario 
	RENAME TO colaborador;

ALTER TABLE Departamento  
	RENAME TO departamento;

ALTER TABLE Dependente  
	RENAME TO dependente;

SHOW TABLES;

SELECT * FROM colaborador;

ALTER TABLE colaborador 
	ADD COLUMN nome_completo VARCHAR(128) NOT NULL;

UPDATE colaborador
	SET nome_completo = CONCAT(primeiro_nome, '', ultimo_nome)
	WHERE id < 100;

SELECT * FROM colaborador;
	
ALTER TABLE colaborador 
	MODIFY COLUMN nome_completo VARCHAR(128) NOT NULL,
	DROP COLUMN primeiro_nome,
	DROP COLUMN ultimo_nome;

select * from colaborador;
