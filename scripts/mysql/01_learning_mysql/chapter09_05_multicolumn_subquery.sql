-- Multicolumn Subqueries

SELECT branch.branch_id
FROM branch
WHERE name = 'Woburn Branch';

SELECT employee.emp_id
FROM employee
WHERE title IN ('Teller', 'Head Teller');

-- The main query uses two subqueries to identify the ID of the 'Woburn Branch'
-- and the IDs of all the bank tellers, and containing query then ues
-- this information to retrieve all the checking account opened by a teller
-- at the 'Woburn Branch'

SELECT account_id, product_cd, cust_id
FROM account
WHERE open_branch_id = (SELECT branch.branch_id
                        FROM branch
                        WHERE name = 'Woburn Branch')
  AND open_emp_id IN (SELECT employee.emp_id
                      FROM employee
                      WHERE title IN ('Teller', 'Head Teller'));

-- another version

SELECT account_id, product_cd, cust_id
FROM account
WHERE (open_branch_id, open_emp_id) IN
      (SELECT b.branch_id, e.emp_id
       FROM branch AS b
                INNER JOIN employee AS e
                           ON b.branch_id = e.assigned_branch_id
       WHERE b.name = 'Woburn Branch'
         AND title IN ('Teller', 'Head Teller'));


