-- 1.
-- Simple Grouping: How many employees are in each department? Show dept_id and the count.

SELECT dept_id, COUNT(emp_id) AS number_of_employees
FROM employee
GROUP BY dept_id;

-- 2.
-- Aggregate Functions: For each product type (use product_cd), show:
-- The number of accounts
-- The average balance
-- The highest balance
-- The total of all balances

SELECT COUNT(product_cd)  AS number_of_accounts_per_product,
       AVG(avail_balance) AS average_balance,
       MAX(avail_balance) AS highest_balance,
       SUM(avail_balance) AS total_of_all_balances
FROM account
GROUP BY product_cd;

-- 3.
-- HAVING Clause: Which customers (show cust_id) have more than 1 account?
SELECT cust_id, COUNT(cust_id) AS more_than_one_account
FROM account
GROUP BY cust_id
HAVING COUNT(cust_id) > 1;

-- 4.
-- Two-Column Grouping: Show the count of accounts grouped by both product_cd and open_branch_id.
SELECT COUNT(account_id), product_cd, open_branch_id
FROM account
GROUP BY product_cd, open_branch_id;

-- 5.
-- Challenge: Show the total balance for each customer,
--  but only include customers whose total balance exceeds $5,000.
--  Use cust_id and SUM(avail_balance).
SELECT cust_id, SUM(avail_balance) AS total_balance
FROM account
GROUP BY cust_id
HAVING SUM(avail_balance) > 5000;
