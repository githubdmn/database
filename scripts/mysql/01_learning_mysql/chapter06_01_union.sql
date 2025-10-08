--	The `union` and `union all` operations allow comining multiple data sets.
--	The `union` opearation sorts the combined set and removes duplicates,
--	whereas `union all` does not and with `union all`, the number of rows 
--	in the final dataset will always equal the sum of the number of rows
--	in the set being combined.
SELECT 'IND' AS type_cd,
       cust_id,
       lname AS name
FROM individual
UNION ALL
SELECT 'BUS' AS type_cd,
       cust_id,
       name
FROM business;
--
-- UNION ALL - duplicates are kept
SELECT 'IND' AS type_cd,
       cust_id,
       lname AS name
FROM individual
UNION ALL
SELECT 'BUS' AS type_cd,
       cust_id,
       name
FROM business
UNION ALL
SELECT 'BUS' AS type_cd,
       cust_id,
       name
FROM business;
--
-- The query that returns duplicate data:
SELECT emp_id
FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
UNION ALL
SELECT DISTINCT open_emp_id
FROM account
WHERE open_branch_id = 2;
--
-- unlike the previous example, this UNION excludes duplicate rows
SELECT emp_id
FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
UNION
SELECT DISTINCT open_emp_id
FROM account
WHERE open_branch_id = 2;