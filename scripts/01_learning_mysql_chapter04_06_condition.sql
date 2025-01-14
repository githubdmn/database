
SELECT emp_id, fname, lname
FROM employee
WHERE LEFT(lname, 1) = 'T';
--
-- for search expressions use LIKE
--
SELECT lname
FROM employee
WHERE lname LIKE '_a%e%';
--
SELECT cust_id, fed_id
FROM customer
WHERE fed_id LIKE '___-__-____';
--
SELECT emp_id, fname, lname
FROM employee 
-- WHERE lname LIKE 'F%' OR lname LIKE 'G%'; 
WHERE lname REGEXP '^[FG]'; 
