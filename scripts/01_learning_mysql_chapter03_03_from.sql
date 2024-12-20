
-- Subquery servs the role if generating temporaty table that is visible
--  from all other query clauses and can interact with other tables named 
-- in the FROM clause

SELECT 
  e.emp_id, e.fname, e.lname
FROM
  (
    SELECT emp_id, fname, lname, start_date, title
    FROM employee
  ) AS e;


