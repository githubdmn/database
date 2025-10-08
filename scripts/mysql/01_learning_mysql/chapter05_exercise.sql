-- EXERCISE 5.1
SELECT
        e.emp_id, e.fname, e.lname, b.name
FROM employee AS e INNER JOIN branch AS b
ON e.assigned_branch_id = b.branch_id;

-- EXERCISE 5.2
-- Write a query that returns the account ID for each nonbusiness customer
-- (customer.cust_type_cd = 'I') with the customer's federal ID (customer.fed_id)
-- and the name of the product on which the account is based (product.name)
SELECT a.account_id
FROM account AS a
    INNER JOIN customer AS c
    ON a.cust_id = c.cust_id
    INNER JOIN product AS p
            ON p.product_cd = a.product_cd
WHERE  c.cust_type_cd = 'I';


-- EXERCISE 5.3
-- Construct a query that finds all the employees whose
-- supervisor is assigned to a different department (from the employee).
-- Retrieve the employees' ID, first name and last name.

SELECT e.emp_id, e.fname, e.lname, e.dept_id, mgr.dept_id
    FROM employee e INNER JOIN employee mgr
ON e.superior_emp_id = mgr.emp_id
 WHERE e.dept_id != mgr.dept_id;


