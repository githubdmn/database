-- A view is a virtual table that presents data from one or more underlying tables.


-- Virtual Table: A view doesn't physically store any data itself. Instead, it acts as a window or a saved query that dynamically retrieves data from the base tables whenever it's accessed.   
-- Data Presentation: Views can be used to:
--  Simplify complex queries: By encapsulating a complex query within a view, you can make it easier to use and understand.   
--  Present customized data: You can create views to show specific subsets of data, filtered or aggregated in a particular way.   
--  Restrict access to data: Views can be used to grant users access to only specific parts of the database without giving them full access to the underlying tables.   
--  Improve data security: By creating views that only expose a limited set of data, you can enhance the security of your database.   

CREATE VIEW employee_vw AS 
  SELECT 
    emp_id,
    fname,
    lname,
    YEAR(start_date) start_year
  FROM 
    employee;

SELECT
  emp_id,
  start_year
FROM
  employee_vw;


