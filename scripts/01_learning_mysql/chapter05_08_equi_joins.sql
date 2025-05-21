-- thus far all examples are equi-join
-- meaning that values from the two tables must match for the join to succeed
-- an equi-join always employees equal sign, like so:
-- ON e.assigned_branch_id = b.branch_id

-- non-equi-join
-- tables employee and product have no foreign key relationships
-- find an employee who began working for the bank while the
-- "No-fee checking" product was being offered.
SELECT e.emp_id, e.fname, e.lname, e.start_date
FROM employee AS e
    INNER JOIN product AS p
    ON e.start_date >= p.date_offered
    AND e.start_date <= p.date_retired
WHERE p.name = 'no-fee checking';

-- self-non-equi-join
-- example of chess tournament for all employees
-- create the list with all the parings
SELECT
    e1.fname, e1.lname, ' -- vs -- ' AS vs, e2.fname, e2.lname
FROM employee AS e1 INNER JOIN employee AS e2
    ON e1.emp_id != e2.emp_id
WHERE e1.title = 'Teller' AND e2.title = 'Teller';

-- there's an issue of pairing and it's reverse pairing
-- e.g. Sarah Parker vs Chris Tucker and Chris Tucker vs Sarah Parker
-- Solution: each teller is paired only with those tellers having a higher employee ID
SELECT
    e1.fname, e1.lname, ' -- vs -- ' AS vs, e2.fname, e2.lname
FROM employee AS e1 INNER JOIN employee AS e2
                               ON e1.emp_id < e2.emp_id
WHERE e1.title = 'Teller' AND e2.title = 'Teller';



