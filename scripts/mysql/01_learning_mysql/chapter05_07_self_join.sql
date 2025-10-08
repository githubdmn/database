-- SELF JOIN
-- employee table contains self-referencing foreign key superior_emp_id
-- for example list all the employees with their superior
-- NOTE:
    -- the result will show 17 employees (of 18 total),
    -- Michael Smith has no superior, so the join fails in that case.

SELECT
    emp.fname AS employee_first_name,
    emp.lname AS employee_last_name,
    mng.fname AS manager_first_name,
    mng.lname AS manager_last_name
FROM employee AS emp
    INNER JOIN employee AS mng
    ON emp.superior_emp_id = mng.emp_id;
