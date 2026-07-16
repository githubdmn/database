-- Total balance by product AND branch
SELECT product_cd,
       open_branch_id,
       SUM(avail_balance) AS total_balance
FROM account
GROUP BY product_cd, open_branch_id;

-- Count employees by department and title
SELECT dept_id,
       title,
       COUNT(*) AS num_employees
FROM employee
GROUP BY dept_id, title
ORDER BY dept_id, title;

-- which groups employees by the year they began working for the bank
SELECT EXTRACT(YEAR FROM start_date) AS year,
       COUNT(*)                         how_many
FROM employee
GROUP BY EXTRACT(YEAR FROM start_date);