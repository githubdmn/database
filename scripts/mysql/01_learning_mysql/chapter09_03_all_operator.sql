-- The `ALL` operator allows the comparison between a single value and
-- every value in a set.
-- Find all employees who are not supervisors
-- employees whose employee IDs are not
-- equal to any of the supervisor employee IDs.

-- The subquery returns the set of IDs for those employees
-- who supervise others.
SELECT DISTINCT superior_emp_id
FROM employee
WHERE superior_emp_id is NOT NULL;

-- The main query
SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id <> ALL (SELECT DISTINCT superior_emp_id
                     FROM employee
                     WHERE superior_emp_id is NOT NULL);


-- Find accounts having an available balance smaller
-- than all of 'Frank Tucker\'s' account
    -- Frank has two accounts. The query finds all accounts having
    -- a balance smaller than any of Frank's accounts.
-- The subquery
SELECT a.avail_balance
FROM account AS a
         INNER JOIN individual AS i
                    ON a.cust_id = i.cust_id
WHERE i.fname = 'Frank'
  AND i.lname = 'Tucker';

-- The main query
SELECT account_id, cust_id, product_cd, avail_balance
FROM account AS a
WHERE avail_balance < ALL (SELECT a.avail_balance
                           FROM account AS a
                                    INNER JOIN individual AS i
                                               ON a.cust_id = i.cust_id
                           WHERE i.fname = 'Frank'
                             AND i.lname = 'Tucker');



