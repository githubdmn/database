-- INNER JOIN

SELECT employee.fname, employee.lname, department.name
FROM employee 
  JOIN department
  ON employee.dept_id = department.dept_id;

SELECT employee.fname, employee.lname, department.name
FROM employee
  INNER JOIN department
  ON employee.dept_id = department.dept_id;

-- equivalent for:
--  ON emplyee.dept_id = department.dept_id; 
-- is: 
--  USING(dept_id) 

