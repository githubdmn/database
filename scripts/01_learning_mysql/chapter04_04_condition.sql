SELECT 
	account_id, product_cd, cust_id, avail_balance
FROM 
	account 
WHERE 
	-- product_cd = 'CHK' OR product_cd = 'SAV' OR product_cd = 'CD' OR product_cd = 'MM';
	 product_cd IN ('CHK', 'SAV', 'CD', 'MM');
	-- product_cd NOT IN ('CHK', 'SAV', 'CD', 'MM');

