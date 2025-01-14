
-- Exercise 1
SELECT * 
FROM transaction 
WHERE txn_date > '2005-02-26' AND (txn_type_cd='DBT' OR amount > 100);

-- Exercise 2
SELECT *
FROM transaction
WHERE account_id IN (101, 103) AND NOT (txn_type_cd='DBT' OR amount > 100);

-- Exercise 3: Construct a query that retrieves all accounts opened in 2002
SELECT account_id, open_date
FROM account
WHERE open_date LIKE '2002%';

-- Exercise 4: Cronstuct a query that finds all nonbusiness customers 
  -- whose last name contains an 'a' in the second position and
  -- an 'e' anywhere after the a.
SELECT * 
FROM employee 
WHERE lname like '_a%e%';
