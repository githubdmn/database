
-- exercise 1:
	-- retrieve the employee ID, first name and last name from all bank employees.
	-- sort by last name and then by first name.
SELECT 
	emp_id, 
	fname, 
	lname 
FROM 
	employee
ORDER BY lname, fname;


-- exercise 2:
	-- retrieve the account ID,customer ID and available ablance for all
	-- from account table
	-- accounts whose status equals 'ACTIVE' and whose balance is greater 
	-- than $2,500
SELECT
	account_id, 
	cust_id , 
	avail_balance
FROM 
	account
WHERE 
	status = 'ACTIVE' AND avail_balance > 2500 ;
	
	
-- exercise 3:
	-- write a query against the account table that returns 
	-- the IDs of the employees who opened the accounts / account.open_emp_id
	-- include a single row for each distinct employee
SELECT DISTINCT open_emp_id 
FROM 
	account 
	INNER JOIN employee 
	ON account.open_emp_id = employee.emp_id;

-- exercise 4 - write the correct value instead of <#>
/*
SELECT 
	p.product_cd, 
	a.cust_id, 
	a.avail_balance
FROM 
	product as p 
	INNER JOIN account <1>
	ON p.product_cd = <2>
WHERE 
	p.<3> = 'ACCOUNT'
ORDER BY 
	<4>, <5>
*/

SELECT 
	p.product_cd, 
	a.cust_id, 
	a.avail_balance 
FROM 
	product as p 
	INNER JOIN account as a 
	ON p.product_cd = a.product_cd 
WHERE 
	p.product_type_cd = 'ACCOUNT' 
ORDER BY 
	product_cd, cust_id; 
	