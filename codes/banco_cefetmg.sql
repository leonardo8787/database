create database banco_cefetmg;
use banco_cefetmg;

create table contas (
	id int primary key,
	saldo float not null default 0
);

show tables;


show databases;

insert into contas (id, saldo) values 
	(1, 150.00); 

select * from contas;

rollback;

select * from contas;

 -- Executando transações 

start transaction;
insert into contas(id, saldo) values 
	(2, 5000.00);

select * from contas;

rollback;

select * from contas;

start transaction;
insert into contas(id, saldo) values 
	(2, 5000.00);
select * from contas;
commit;

select * from contas;


-- transferir R$ 500,00 da conta 2 para a conta 1
start transaction;
update contas set saldo = saldo - 500 where id = 2;
update contas set saldo = saldo + 500 where id = 1;
select * from contas;

rollback;

select * from contas;

start transaction;
update contas set saldo = saldo - 500 where id = 2;
update contas set saldo = saldo + 500 where id = 1;
select * from contas;
commit;

select * from contas;

select sum(saldo) from contas;

start transaction;
select * from contas where id = 2 for update;
update contas set saldo = saldo - 200 where id = 2;
-- varias outras coisas --
commit;

start transaction;
select * from contas where id = 1 for share;
select * from contas where id = 2 for share;
commit;

start transaction;
select * from contas where id = 1 for update;
select * from contas where id = 2 for update;
update contas set saldo = saldo + 50 where id = 1;
update contas set saldo = saldo + 50 where id = 2;


