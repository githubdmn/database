
-- Avoid mixing CROSS JOIN with ON
-- —it’s non-standard and confusing. Use INNER JOIN instead.

SELECT employee.fname, employee.lname, department.name
FROM employee 
  CROSS JOIN department;
  -- ON employee.dept_id = department.dept_id; -- ❌ Invalid syntax

-- CROSS JOIN creates a Cartesian product (every combination of rows from both tables) first.
-- The ON clause is then applied after the Cartesian product is created.
-- This is not standard SQL syntax. Most databases (like MySQL)
-- will ignore the ON clause with CROSS JOIN and return
-- the full Cartesian product (e.g., 18 employees × 3 departments = 54 rows).

-- INNER JOIN
SELECT employee.fname, employee.lname, department.name
FROM employee
  INNER JOIN department
  ON employee.dept_id = department.dept_id;

-- INNER JOIN matches rows only where dept_id exists in both tables.
-- The ON clause filters the result during the join, not afterward.
-- Only employees assigned to valid departments (e.g., 18 employees × 1 department each = 18 rows).

-- equivalent for:
--  ON emplyee.dept_id = department.dept_id; 
-- is: 
--  USING(dept_id) 

