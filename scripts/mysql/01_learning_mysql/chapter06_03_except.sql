-- The except operator returns the first table minus any overlap with the second table.

SELECT emp_id
FROM employee
WHERE  assigned_branch_id = 2
    AND (title = 'Teller' OR title = 'Head Teller')
EXCEPT
SELECT  DISTINCT open_emp_id
FROM account
WHERE  open_emp_id = 2;

