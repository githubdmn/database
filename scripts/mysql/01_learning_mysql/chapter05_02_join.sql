-- This is called "cross join" or just "join"

SELECT e.fname, e.lname, d.name
FROM 
	employee AS e 
	CROSS JOIN department AS d;
    -- JOIN department as d;
	
	-- Because the query does not specify how are tables joined
	-- the database server generates CARTESIAN PRODUCT
	-- which is permitation of the two tables (18 emp x 3 dep = 54 permutations)
	-- This is called "cross join"
    -- Avoid mixing CROSS JOIN with ON—it’s non-standard and confusing.
	
	