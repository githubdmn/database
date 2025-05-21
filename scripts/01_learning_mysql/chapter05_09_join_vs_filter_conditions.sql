-- compare the following statements (a, b and c)

SELECT a.account_id,
       a.product_cd,
       c.fed_id
FROM account AS a
         INNER JOIN customer as c
                    ON a.cust_id = c.cust_id
WHERE c.cust_type_cd = 'B';

SELECT a.account_id,
       a.product_cd,
       c.fed_id
FROM account AS a
         INNER JOIN customer as c
                    ON a.cust_id = c.cust_id
                        AND c.cust_type_cd = 'B';


SELECT a.account_id,
       a.product_cd,
       c.fed_id
FROM account AS a
         INNER JOIN customer as c
WHERE a.cust_id = c.cust_id
  AND c.cust_type_cd = 'B';

-- explain the difference between the conditions from the statements a, b and c