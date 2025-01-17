SELECT *
FROM department;

SELECT dept_id,
        name
FROM department;

SELECT name
FROM department;

SELECT emp_id,
        'ACTIVE',
        emp_id * 3.14159,
        UPPER(lname)
FROM employee;

SELECT VERSION(),
        USER(),
        DATABASE();

SELECT emp_id,
        'ACTIVE' AS status,
        -- AS can be ommited
        emp_id * 3.14159 AS empid_x_pi,
        -- AS can be ommited
        UPPER(lname) AS last_name_upper -- AS can be ommited
FROM employee;

SELECT cust_id
FROM account;

-- REMOVING DUPLICATES
SELECT DISTINCT cust_id
FROM account;

SELECT COUNT(cust_id) FROM account;

SELECT COUNT(DISTINCT cust_id) FROM account;
