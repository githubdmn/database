-- Subqueries can act as derived tables in your FROM clause.
-- This is useful when you need to:
--  * Pre-aggregate or pre-filter data before joining
--  * Avoid complex nested joins
--  * Create a temporary result set that doesn't exist as a real table

-- This subquery generates a list of department IDs along with the
-- number of employees assigned to each department
SELECT dept_id, COUNT(*) how_many
FROM employee
GROUP BY dept_id;

SELECT department.dept_id, department.name, employees.how_many
FROM department
         INNER JOIN
     (SELECT dept_id, COUNT(*) how_many
      FROM employee
      GROUP BY dept_id) AS employees
     ON department.dept_id = employees.dept_id;

-- --

SELECT 'Small Fry' AS name, 0 AS low_limit, 4999.99 AS high_limit
UNION ALL
SELECT 'Average Joes' AS name, 5000 AS low_limit, 9999.99 AS high_limit
UNION ALL
SELECT 'Heavy Hitters' AS name, 10000 AS low_limit, 999999.99 AS high_limit;

SELECT SUM(a.avail_balance) AS customer_ballance
FROM account AS a
         INNER JOIN product AS p
                    ON a.product_cd = p.product_cd
WHERE p.product_type_cd = 'ACCOUNT'
GROUP BY a.cust_id;

SELECT customer_groups.name, COUNT(*) num_customers
FROM (SELECT SUM(a.avail_balance) AS customer_ballance
      FROM account AS a
               INNER JOIN product AS p
                          ON a.product_cd = p.product_cd
      WHERE p.product_type_cd = 'ACCOUNT'
      GROUP BY a.cust_id) AS cust_rollup
         INNER JOIN
     (SELECT 'Small Fry' AS name, 0 AS low_limit, 4999.99 AS high_limit
      UNION ALL
      SELECT 'Average Joes' AS name, 5000 AS low_limit, 9999.99 AS high_limit
      UNION ALL
      SELECT 'Heavy Hitters' AS name, 10000 AS low_limit, 999999.99 AS high_limit) AS customer_groups
     ON cust_rollup.customer_ballance BETWEEN customer_groups.low_limit AND customer_groups.high_limit
GROUP BY customer_groups.name;