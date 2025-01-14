SELECT 
	pt.name AS product_type, 
	p.name AS product
FROM 
	product AS p
		INNER JOIN product_type AS pt
		ON p.product_type_cd = pt.product_type_cd
WHERE
	pt.name <> 'Customer Accounts';
	

-- delete example
DELETE
FROM 
	account
WHERE 
	status = 'CLOSED' AND 
	YEAR(close_date) = 2002;