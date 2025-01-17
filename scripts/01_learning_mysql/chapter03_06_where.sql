-- The WHERE clause
-- mechanism for filtering out unwanted rows from the result set
SELECT
        emp_id    ,
        fname     ,
        lname     ,
        start_date,
        title
FROM
        employee
WHERE
        title = 'Head Teller';
--
SELECT
        emp_id    ,
        fname     ,
        lname     ,
        start_date,
        title
FROM
        employee
WHERE
        title      = 'Head Teller'
AND     start_date > '2002-01-01';
--
SELECT
        emp_id    ,
        fname     ,
        lname     ,
        start_date,
        title
FROM
        employee
WHERE
        title      = 'Head Teller'
OR      start_date > '2003-01-01';
--
SELECT
        emp_id    ,
        fname     ,
        lname     ,
        start_date,
        title
FROM
        employee
WHERE
        (
                title          = 'Head Teller'
                AND start_date > '2003-01-01')
OR      (
                title          = 'Teller'
                AND start_date > '2003-01-01');
				
				