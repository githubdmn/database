-- The `ANY` operator allows the comparison between a single value and
-- every value in a set until the first one is met.
    -- Equivalent of `IN`

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
WHERE avail_balance > ANY (SELECT a.avail_balance
                           FROM account AS a
                                    INNER JOIN individual AS i
                                               ON a.cust_id = i.cust_id
                           WHERE i.fname = 'Frank'
                             AND i.lname = 'Tucker');

-- Frank has two accounts with balances of $1,057.75 and $2,212.50, to have
-- a balance greater than any of these two accounts, an account must have
-- a balance of at least $1,057.75.