SELECT now();
select CURDATE();
SELECT curtime();
select year ('2022-08-27 14:00:00');
select month ('2022-08-27 14:00:00');
select minute ('2022-08-27 14:00:00');
select seconds ('2022-08-27 14:00:00');

select to_days ('1997-12-29 09:05:00');
select to_seconds ('1997-12-29 09:05:00');

select ADDDATE(NOW(), INTERVAL 42 DAY);
select ADDDATE(NOW(), INTERVAL 42000000 SECOND);
select adddate('1997-12-29 09:05:00', INTERVAL 24 YEAR);

SELECT DATE( SUBDATE(NOW(), INTERVAL 42 DAY));

SELECT TO_DAYS('2022-08-27') - TO_DAYS(NOW())
SELECT '2022-08-27' = DATE(NOW());
SELECT '2022-08-27' > DATE(NOW());
