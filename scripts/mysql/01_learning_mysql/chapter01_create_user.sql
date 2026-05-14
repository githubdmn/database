CREATE DATABASE bank;
-- USE bank;
GRANT ALL PRIVILEGES
    ON bank.*
    TO 'user'@'%' WITH GRANT OPTION;


 -- GRANT CREATE ON *.* TO 'user'@'%';
 -- GRANT ALL PRIVILEGES ON `playground`.* TO 'user'@'%' WITH GRANT;
 -- GRANT ALL PRIVILEGES ON *.* TO 'user'@'%';
 
 -- REFRESH PERMISSIONS
 -- FLUSH PRIVILEGES;


-- 1. Create the user
-- CREATE USER 'super'@'localhost' IDENTIFIED BY 'super';

-- 2. Grant all powers on all databases and tables
-- GRANT ALL PRIVILEGES ON *.* TO 'super'@'localhost' WITH GRANT OPTION;

-- 3. Refresh the internal privilege tables
-- FLUSH PRIVILEGES;
