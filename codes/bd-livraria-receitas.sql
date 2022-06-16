CREATE DATABASE livroreceita;

USE livroreceita;

CREATE TABLE usuario (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	telefone VARCHAR(15),
	senha VARCHAR(30) NOT NULL,
    nome VARCHAR(50),
    cidade VARCHAR(20),
    estado VARCHAR(15),
    foto VARCHAR(15)
);
    
CREATE TABLE ingredientes (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50)
);

CREATE TABLE receitas(
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(15),
    rendimento INTEGER,
    tempo INTEGER,
    infor VARCHAR(50),
    usuario_id INTEGER,
    CONSTRAINT FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);	

CREATE TABLE receitas_fotos (
	receita_id INTEGER,
    arquivo VARCHAR(30),
    
    CONSTRAINT PRIMARY KEY(receita_id,arquivo),
	CONSTRAINT FOREIGN KEY (receita_id) REFERENCES receitas(id)
);

CREATE TABLE receitas_ingredientes(
	receita_id INTEGER,
    ingrediente_id INTEGER,
    quantidade INTEGER,
    unidade INTEGER,
    
	CONSTRAINT PRIMARY KEY (receita_id,ingrediente_id),
	CONSTRAINT FOREIGN KEY (receita_id) REFERENCES receitas(id),
	CONSTRAINT FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id)
);

CREATE TABLE receitas_etapas(
	receita_id INTEGER,
    numero INTEGER NOT NULL,
    titulo VARCHAR(20),
    
    CONSTRAINT PRIMARY KEY (receita_id,numero),
	CONSTRAINT FOREIGN KEY (receita_id) REFERENCES receitas(id)    
);

CREATE TABLE receitas_passos(
	receita_id INTEGER,
    etapa_numero INTEGER,
    sequencia INTEGER,
    instrucao VARCHAR(120),
    CONSTRAINT FOREIGN KEY (receita_id, etapa_numero) REFERENCES receitas_etapas(receita_id,numero)
);

CREATE TABLE comentarios(
	usuario_id INTEGER,
    receita_id INTEGER,
    data_hora INTEGER,
    mensagem VARCHAR(350)
);
