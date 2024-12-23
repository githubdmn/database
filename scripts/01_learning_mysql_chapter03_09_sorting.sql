SELECT
	account_id,
	product_cd,
	open_date ,
	avail_balance
FROM
	account
ORDER BY
	avail_balance DESC;
	
SELECT
	emp_id     ,
	title,
	start_date        ,
	fname       ,
	lname
FROM
	employee
ORDER BY 2, 5;