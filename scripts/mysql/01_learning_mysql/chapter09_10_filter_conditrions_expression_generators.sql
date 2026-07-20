
-- Subqueries in filter conditions
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
HAVING COUNT(*) = (SELECT MAX(emp_cnt.how_many)
                   FROM (SELECT COUNT(*) AS how_many
                         FROM account
                         GROUP BY open_emp_id) AS emp_cnt);

-- subqueries as expression generators





