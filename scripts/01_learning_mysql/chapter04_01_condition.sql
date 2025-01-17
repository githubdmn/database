SELECT 
	*
FROM 
	employee
WHERE 
	title = 'Teller' AND start_date < '2007-01-01';
	
SELECT 
	*
FROM 
	employee
WHERE 
	title = 'Teller' OR start_date < '2007-01-01';
	
SELECT 
	*
FROM 
	employee
WHERE 
	superior_emp_id IS NULL;
	
SELECT 
	*
FROM 
	employee
WHERE 
	superior_emp_id IS NOT NULL;
	