mysql> SELECT  f.id, f.nome, f.sobrenome, f.salario + COUNT(*) * 100 AS salario_total FROM Funcionario AS f, Dependente AS d WHERE f.id = d.id_fun GROUP BY f.id;

mysql> select * from Funcionario as f left outer join Dependente as d on f.id = d.id_fun;

mysql> SELECT 
    -> f.id, f.nome, f.sobrenome, f.salario, COUNT(d.id) AS num_dependentes,
    -> f.salario + COUNT(d.id) * 100 AS salario_total
    -> FROM Funcionario AS f LEFT OUTER JOIN Dependente AS d ON f.id = d.id_fun
    -> GROUP BY f.id
    -> ORDER BY f.id
    -> LIMIT 5 OFFSET 10;


