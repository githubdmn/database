--
SELECT c.cust_id, c.cust_type_cd, c.city
    FROM customer AS c
WHERE  2 = (SELECT COUNT(*)
            FROM account AS a
            WHERE a.cust_id = c.cust_id);

SELECT c.cust_id, c.cust_type_cd, c.city
FROM customer AS c
WHERE (SELECT SUM(a.avail_balance)
            FROM account AS a
            WHERE a.cust_id = c.cust_id)
BETWEEN 5000 AND 10000;
