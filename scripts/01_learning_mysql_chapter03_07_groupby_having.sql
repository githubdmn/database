-- GROUP and HAVING simple example
SELECT
        d.name,
        COUNT(e.emp_id) as number_of_employees
FROM
        department as d
INNER JOIN
        employee AS e
ON
        d.dept_id = e.dept_id
GROUP BY
        d.name
HAVING
        COUNT(e.emp_id) > 2;