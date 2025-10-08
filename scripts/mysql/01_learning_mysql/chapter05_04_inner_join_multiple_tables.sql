-- Joining two tables
SELECT a.account_id, c.fed_id
FROM account AS a INNER JOIN customer AS c
ON a.cust_id = c.cust_id
WHERE c.cust_type_cd = 'B';

-- Joining three or more tables
SELECT a.account_id, c.fed_id, e.fname, e.lname
FROM account AS a
    INNER JOIN customer AS c
    ON a.cust_id = c.cust_id
    INNER JOIN employee AS e
    ON a.open_emp_id = e.emp_id
WHERE c.cust_type_cd = 'B';

-- INNER JOIN is commutative: The order of tables in INNER JOIN
-- does not affect the final result because only matching rows are included.
-- SQL optimizers: Most databases reorder joins internally for efficiency.
-- The written order is a hint, not a strict instruction.

SELECT a.account_id, c.fed_id, e.fname, e.lname
FROM customer AS c
         INNER JOIN account AS a
                    ON a.cust_id = c.cust_id
         INNER JOIN employee AS e
                    ON a.open_emp_id = e.emp_id
WHERE c.cust_type_cd = 'B';

SELECT a.account_id, c.fed_id, e.fname, e.lname
FROM employee AS e
         INNER JOIN account AS a
                    ON a.open_emp_id = e.emp_id
         INNER JOIN customer AS c
                    ON a.cust_id = c.cust_id
WHERE c.cust_type_cd = 'B';