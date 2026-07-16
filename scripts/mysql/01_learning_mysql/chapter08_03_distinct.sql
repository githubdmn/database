-- Employee responsible for opening each account
SELECT account_id,
       open_emp_id
FROM account
ORDER BY open_emp_id;

SELECT COUNT(open_emp_id)
FROM account;

-- How many DISTINCT employees are responsible for each account
SELECT COUNT(DISTINCT open_emp_id)
FROM account;
