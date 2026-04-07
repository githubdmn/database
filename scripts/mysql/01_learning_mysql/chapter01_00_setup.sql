-- 1. Create the user
CREATE USER 'super'@'localhost' IDENTIFIED BY 'super';

-- 2. Grant all powers on all databases and tables
GRANT ALL PRIVILEGES ON *.* TO 'super'@'localhost' WITH GRANT OPTION;

-- 3. Refresh the internal privilege tables
FLUSH PRIVILEGES;
