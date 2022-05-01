mysql comandos

sudo mysql
SHOW DATABASES;

criar um banco de dados:
create database [nome];  -> cria banco de dados
drop database [nome];  -> apaga banco de dados 
drop database if exists [nome]; -> apaga banco de dados e evita de dar erros
create database if not exists [nome]; -> cria o banco de dados e evita erros

para usar um banco de dados específico:
use [nome];
show tables -> checa se há tabelas no banco de dados 
create table [nome tabela] (  -> cria a tabela e deixa em aberto para colocar a coluna 

define colunas na tebela:
[identificador] [tipo], -> cria coluna de dados
[identificador] [tipo] primary key, -> cria coluna de dados unitários
[identificador] [tipo] not null, -> não permite valor nulo

describe contato; -> descreve como está a tabela
insert into [nome-atributos] values [atributos] -> insere informações na tabela 

select * from [nome banco de dados]; -> mostra o que tem no banco de dados 

select [nome procurado] from [banco de dados]; -> procura "coisa" especifica



Senha: Leo@89878987
mysql -u admin -p

senha root mysql: Root@89878987



