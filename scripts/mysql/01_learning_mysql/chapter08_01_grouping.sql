-- The core idea here is moving from raw data (every single row) 
-- to summarized data (totals, averages, counts, etc.).

-- "How many accounts did each employee open?"
SELECT open_emp_id AS employee_id
FROM account;
--
SELECT open_emp_id AS employee_id
FROM account
GROUP BY open_emp_id;
--
-- COUNT(*) counts the number of rows in each group
SELECT open_emp_id AS employee_id,
       COUNT(*)    AS how_many
FROM account
GROUP BY open_emp_id;
--
--  Using Multiple Aggregate Functions
SELECT product_cd,
       COUNT(*)           AS num_accounts,
       MAX(avail_balance) AS highest_balance,
       MIN(avail_balance) AS lowest_balance,
       AVG(avail_balance) AS avg_balance,
       SUM(avail_balance) AS total_balance
FROM account
GROUP BY product_cd;
--
-- For each product, how many accounts are there, and what are the max, min, average, and total balances?
-- Group by branch and show account statistics
SELECT open_branch_id,
       COUNT(*)           AS num_accounts,
       SUM(avail_balance) AS total_deposits
FROM account
GROUP BY open_branch_id;
