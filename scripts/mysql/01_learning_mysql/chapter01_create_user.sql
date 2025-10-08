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
