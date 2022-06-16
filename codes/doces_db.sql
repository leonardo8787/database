drop database if exists cefet_receitas;
create database cefet_receitas;
use cefet_receitas;

create table usuarios(
	id binary(16) primary key,
	nome varchar(64) not null,
	telefone char(11) not null unique,
	email varchar(128) not null unique,
	cidade varchar(64) not null,
	estado char(2) not null,
	foto varchar(128) not null
);

create table credenciais(
	id binary(16) primary key,
	senha binary(32) not null,
	foreign key (id) references usuarios(id)
);

create table ingredientes(
	id int primary key auto_increment,
	nome varchar(128) not null unique
);

create table receitas(
	id int primary key auto_increment,
	usuario_id binary(16),
	nome varchar(128) not null,
	rendimento int not null,
	tempo int not null,
	info text,
	foreign key (usuario_id) references usuarios(id)
);

create table receitas_fotos(
	receita_id int not null,
	arquivo varchar(128) not null,
	primary key(receita_id, arquivo),
	foreign key (receita_id) references receitas(id)
);

create table receitas_ingredientes(
	receita_id int not null,
	ingrediente_id int not null,
	quantidade float not null,
	unidade varchar(32) not null,
	primary key(receita_id, ingrediente_id),
	foreign key (receita_id) references receitas(id),
	foreign key (ingrediente_id) references ingredientes(id)
);

create table receitas_etapas (
	receita_id int not null,
	numero int not null,
	titulo varchar(32) not null,
	primary key (receita_id, numero),
	foreign key (receita_id) references receitas (id)
);

create table receitas_passos (
	receita_id int,
	etapa_numero int not null,
	sequencia int not null,
	instrucao varchar(128) not null,
	primary key (receita_id, etapa_numero, sequencia),
	foreign key (receita_id, etapa_numero) references receitas_etapas (receita_id, numero)
);

create table comentarios(
	usuario_id binary(16) not null,
	receita_id int not null,
	data_hora timestamp not null,
	mensagem text,
	primary key(usuario_id, receita_id, data_hora),
	foreign key(usuario_id) references usuarios(id),
	foreign key(receita_id) references receitas(id)
);

create table curtidas(
	usuario_id binary(16) not null,
	receita_id int not null,
	estrelas int not null,
	primary key(usuario_id, receita_id),
	foreign key(usuario_id) references usuarios(id),
	foreign key(receita_id) references receitas(id)
);

create table receitas_salvas(
	usuario_id binary(16) not null,
	receita_id int not null,
	primary key(usuario_id, receita_id),
	foreign key(usuario_id) references usuarios(id),
	foreign key(receita_id) references receitas(id)
);



--receita brigadeiro
insert into ingredientes (id, nome) values 
	(1, 'Leite condensado'),
	(2, 'Margarina sem sal'),
	(3, 'Achocolatado em pó'),
	(4, 'Chocolate granulado');

insert into receitas (id, nome, rendimento, tempo) values 
	(1, 'Brigadeiro', 30, 25);

insert into receitas_ingredientes (receita_id, ingrediente_id, quantidade, unidade) values 
	(1,1,1,'caixa'),
	(1,2,1,'colher de sopa'),
	(1,3,4,'coheres de sopa'),
	(1,4,1,'pacote');

insert into receitas_etapas (receita_id, numero, titulo) values 
	(1,1,'Preparacao do brigadeiro'),
	(1,2,'Montagem dos doces ');

insert into receitas_passos (receita_id, etapa_numero, sequencia, instrucao) values 
	(1,1,1,'Em uma panela funda, acrescente o leite condensado, margarina e o achocolatado'),
	(1,1,2,'Cozinha em fogo médio e mexa até que o brigadeiro comece a desgrudar'),
	(1,2,1,'Deixe esfriar'),
	(1,2,2,'Faça pequenas bolas de brigadeiro com as mãos'),
	(1,2,3,'Passe as bolas de brigadeiro no chocolate granulado');
