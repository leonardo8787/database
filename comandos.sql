USE agenda;
SHOW TABLES;
DESCRIBE CONTATOS;
SHOW CREATE TABLE CONTATOS;
select * from contatos;
insert into contatos (id, nome, telefone) values
(2, 'Maria', '3111110000'),
(3, 'Joao', NULL),
(4, 'Jose', '3788889999');

insert into contatos (nome, id) values
('José', 42),
('Antonio', 10);

delete from contatos where id=42;

delete from contatos where telefone is null;

select nome, telefone from contatos;

select nome,telefone from contatos where id = 2 or id = 4;

-- isso é um comentario
# isso tambem é um comnetário
select id, telefone, nome from contatos where telefone like '37%';

select id, telefone, nome from contatos where nome like '_o%';

select id, telefone, nome from contatos where nome like 'J%e';

select * from contatos order by nome desc;

select nome from contatos;

select distinct nome from contatos;