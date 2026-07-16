-- Important: You cannot use aggregate functions in WHERE. This fails:
-- This will NOT work! -- [HY000][1111] Invalid use of group function ---

SELECT open_emp_id, COUNT(*) AS how_many
FROM account
WHERE COUNT(*) > 4
GROUP BY open_emp_id;

-- INSTEAD use HAVING
-- Find employees who opened 5 or more accounts
SELECT open_emp_id, COUNT(*) AS how_many
FROM account
GROUP BY open_emp_id
HAVING COUNT(*) >= 5;

-- Find products with a total balance over $10,000
SELECT product_cd,
       SUM(avail_balance) AS total_balance
FROM account
GROUP BY product_cd
HAVING SUM(avail_balance) > 10000;
