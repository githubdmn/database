-- subquery 1
SELECT emp_id, assigned_branch_id
FROM employee
WHERE start_date < '2007-01-01'
  AND (title = 'Teller' OR title = 'Head Teller');

-- subquery 2
SELECT branch_id
FROM branch
WHERE name = 'Woburn Branch';

SELECT account_id,
       product_cd,
       cust_id,
       last_activity_date,
       status,
       open_branch_id,
       open_emp_id,
       avail_balance,
       emp_id,
       assigned_branch_id,
       branch_id
FROM account AS a
         INNER JOIN (
    -- subquery 1
    SELECT emp_id, assigned_branch_id
    FROM employee
    WHERE start_date < '2007-01-01'
      AND (title = 'Teller' OR title = 'Head Teller')) AS e ON a.open_emp_id = e.emp_id
         INNER JOIN (
    -- subquery 2
    SELECT branch_id
    FROM branch
    WHERE name = 'Woburn Branch') AS b
                    ON e.assigned_branch_id = b.branch_id;