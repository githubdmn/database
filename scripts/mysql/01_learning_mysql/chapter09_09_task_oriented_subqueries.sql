SELECT product.name                                AS product_name,
       branch.name                                 AS branch_name,
       CONCAT(employee.fname, ' ', employee.lname) AS name,
       SUM(account.avail_balance)                  AS total_deposit
FROM account
         INNER JOIN employee
                    ON account.open_emp_id = employee.emp_id
         INNER JOIN branch
                    ON account.open_branch_id = branch.branch_id
         INNER JOIN product
                    ON account.product_cd = product.product_cd
WHERE product.product_type_cd = 'ACCOUNT'
GROUP BY product.name, branch.name, employee.fname, employee.lname
ORDER BY 1, 2;

-- separate out the task of generating the groups into a subquery
SELECT product_cd, open_emp_id, open_branch_id, SUM(avail_balance) AS total_deposits
FROM account
GROUP BY product_cd, open_branch_id, open_emp_id;

--
-- Potentially faster execution

SELECT product.name                                AS product_name,
       branch.name                                 AS branch_name,
       CONCAT(employee.fname, ' ', employee.lname) AS name,
       account_groups.total_deposits
FROM (SELECT product_cd,
             open_emp_id,
             open_branch_id,
             SUM(avail_balance) AS total_deposits
      FROM account
      GROUP BY product_cd,
               open_branch_id,
               open_emp_id) AS account_groups
         INNER JOIN employee
                    ON account_groups.open_emp_id = employee.emp_id
         INNER JOIN branch
                    ON account_groups.open_branch_id = branch.branch_id
         INNER JOIN product
                    ON account_groups.product_cd = product.product_cd
WHERE product.product_type_cd = 'ACCOUNT';