-- Simple example: Find the account with the highest ID
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE account_id = (SELECT MAX(account_id) FROM account);

-- How this works:
-- The subquery (SELECT MAX(account_id) FROM account) runs first → returns 29
-- The main query becomes: WHERE account_id = 29
-- Result: the row for account_id 29

--
-- Noncorrelated Subqueries
--

-- Return data concering all accounts that were not opened by the head teller at the "Woburn" branch.
-- The subquery:
-- SELECT The Woburn head teller
-- There is only a single head teller at each branch.
SELECT e.emp_id AS employee_id
FROM employee AS e
         INNER JOIN branch AS b
                    ON e.assigned_branch_id = b.branch_id
WHERE e.title = 'Head Teller'
  AND b.city = 'Woburn';

-- Main query
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE open_emp_id <> (SELECT e.emp_id AS employee_id
                      FROM employee AS e
                               INNER JOIN branch AS b
                                          ON e.assigned_branch_id = b.branch_id
                      WHERE e.title = 'Head Teller'
                        AND b.city = 'Woburn');

-- IF THE SUBQUERY return more than one row the database responds with an error.
SELECT e.emp_id AS employee_id
FROM employee AS e
         INNER JOIN branch AS b
                    ON e.assigned_branch_id = b.branch_id
WHERE e.title = 'Teller'
  AND b.city = 'Woburn';

-- Main query -- ERROR: [21000][1242] Subquery returns more than 1 row
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE open_emp_id <> (SELECT e.emp_id AS employee_id
                      FROM employee AS e
                               INNER JOIN branch AS b
                                          ON e.assigned_branch_id = b.branch_id
                      WHERE e.title = 'Teller'
                        AND b.city = 'Woburn');
