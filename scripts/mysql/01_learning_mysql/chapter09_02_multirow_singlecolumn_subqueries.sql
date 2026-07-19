-- Check whether a single value can be found within a set of values

SELECT branch_id, name, city
FROM branch
WHERE name IN ('Headquarters', 'Quincy Branch');

--
SELECT superior_emp_id
FROM employee;

SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id IN (SELECT superior_emp_id
                 FROM employee);

-- to avoid duplicated use distinct
SELECT DISTINCT superior_emp_id
FROM employee;

-- also to remove the NULL from the results
SELECT DISTINCT superior_emp_id
FROM employee
WHERE superior_emp_id IS NOT NULL;


SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id IN (SELECT DISTINCT superior_emp_id
                 FROM employee
                 WHERE superior_emp_id IS NOT NULL);