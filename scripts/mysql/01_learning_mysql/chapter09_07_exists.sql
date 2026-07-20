-- The `EXISTS` operator identifies whether relationship exists
-- without regard for quantity (or value)

SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account AS a
WHERE EXISTS(SELECT 1
             FROM transaction AS t
             WHERE t.account_id = a.account_id
               AND t.txn_date = '2008-09-22');


SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account AS a
WHERE EXISTS(SELECT t.txn_id, 'hello', 3, 1415927
             FROM transaction AS t
             WHERE t.account_id = a.account_id
               AND t.txn_date = '2008-09-22');


-- Customers whose IDs do not appear in the business table

SELECT a.account_id, a.product_cd, a.cust_id
FROM account AS a
WHERE NOT EXISTS(SELECT 1
                 FROM business AS b
                 WHERE b.cust_id = a.cust_id);

UPDATE account AS a
SET a.last_activity_date = (SELECT MAX(t.txn_date)
                            FROM transaction AS t
                            WHERE t.account_id = a.account_id);

-- without where every row in the account table
UPDATE account AS a
SET a.last_activity_date = (SELECT MAX(t.txn_date)
                            FROM transaction AS t
                            WHERE t.account_id = a.account_id)
WHERE EXISTS(SELECT 1
             FROM transaction AS t
             WHERE t.account_id = a.account_id);


-- aliases are NOT allowed with DELETE
DELETE
FROM department
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE employee.dept_id = department.dept_id)

