CREATE TABLE Departamento (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(30) NOT NULL
);

CREATE TABLE Funcionario (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  sobrenome VARCHAR(50) NOT NULL,
  salario REAL NOT NULL,
  id_dept INTEGER NOT NULL,
  CONSTRAINT FOREIGN KEY (id_dept) REFERENCES Departamento (id)
);

CREATE TABLE Dependente (
  id INTEGER AUTO_INCREMENT,
  id_fun INTEGER NOT NULL,
  nome VARCHAR(50) NOT NULL,
  sobrenome VARCHAR(50) NOT NULL,
  CONSTRAINT PRIMARY KEY (id, id_fun),
  CONSTRAINT FOREIGN KEY (id_fun) REFERENCES Funcionario (id)
);

INSERT INTO Departamento (nome) VALUES
  ("Administrativo"),
  ("Financeiro"),
  ("Recursos Humanos"),
  ("Comercial"),
  ("Pesquisa"),
  ("Tecnologia da Informação");
  
INSERT INTO Funcionario (nome, sobrenome, id_dept, salario) VALUES
  ("Adolfo", "Feijó", 1, 7000.0),
  ("Adriana", "Albuquerque", 1, 7000.0),
  ("Adélio", "Saldaña", 2, 5000.0),
  ("Catarina", "Javier", 2, 4000.0),
  ("Cosperranho", "Lira", 3, 3500.0),
  ("Doroteia", "Almeida", 4, 2000.0),
  ("Eládio", "Parreira", 4, 2000.0),
  ("Evandro", "Beiriz", 5, 6500.0),
  ("Evangelista", "Hollanda", 5, 7000.0),
  ("Gabriela", "Brasil", 5, 4200.0),
  ("Heitor", "Seixas", 5, 6500.0),
  ("Inês", "Belém", 6, 4000.0),
  ("Lourenço", "Bicalho", 6, 2000.0),
  ("Marlene", "Vidigal", 6, 2000.0);

INSERT INTO Dependente (nome, sobrenome, id_fun) VALUES
  ("Milena", "Albuquerque", 2),
  ("Osvaldo", "Albuquerque", 2),
  ("Sidónio", "Almeida", 6),
  ("Sérgio", "Bicalho", 13),
  ("Teodorico", "Bicalho", 13),
  ("Virgínia", "Belém", 12);

