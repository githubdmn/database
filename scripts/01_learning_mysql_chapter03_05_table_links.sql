

SELECT 
  employee.emp_id,
  employee.fname,
  employee.lname,
  department.name AS dept_name
FROM 
  employee 
  INNER JOIN department ON employee.dept_id = department.dept_id;

/*
SELECT 
  e.emp_id,
  e.fname,
  e.lname,
  d.name AS dept_name
FROM 
  employee as e 
  INNER JOIN department as d ON e.dept_id = d.dept_id;
*/
