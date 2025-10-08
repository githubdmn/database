-- The Intersect Operator

-- MySQL <= v.6.0 does not support `intersect`
-- SELECT statement in both data sets must have an equal number of columns of same type

-- nonoverlapping data set
SELECT emp_id, fname, lname
FROM employee
INTERSECT
SELECT cust_id, fname, lname
FROM individual;

-- overlapping data set
SELECT emp_id
FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
INTERSECT
SELECT DISTINCT open_emp_id
FROM account
WHERE open_branch_id = 2;



