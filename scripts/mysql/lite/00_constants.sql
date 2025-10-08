CREATE DATABASE IF NOT EXISTS `lite`;

CREATE TABLE IF NOT EXISTS base_id
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    value INT
);

CREATE TABLE constants
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    table_name  VARCHAR(255) NOT NULL,
    column_name VARCHAR(255) NOT NULL,
    value       VARCHAR(255) NOT NULL
);

INSERT INTO constants (table_name, column_name, value)
VALUES ('constants', 'version', '1.0'),
       ('constants', 'db_version', '1.0'),
       ('auth_user', 'status', 'active'),
       ('auth_user', 'status', 'suspended'),
       ('auth_user', 'status', 'deactivated');


CREATE TEMPORARY TABLE temporary_constants
(
    id          INT,
    table_name  VARCHAR(100),
    column_name VARCHAR(100),
    value       VARCHAR(255)
);


CREATE PROCEDURE constants_get_by_table_name(IN in_table_name VARCHAR(255))
BEGIN
    SELECT id, table_name, column_name, value
    FROM constants
    WHERE table_name = in_table_name;
END;


CALL constants_get_by_table_name('auth_user');
SELECT * FROM temporary_constants;

-- However, when you are defining procedural objects like
-- Stored Procedures, Functions, or Triggers, these objects themselves
-- contain multiple standard SQL statements, each ending in a semicolon.
-- The DELIMITER command tells the client to temporarily ignore the semicolon
-- as the statement end marker and use a different character (or sequence of characters) instead.
-- The most common choice is // (double slash) or $$.

-- By changing the delimiter to // before the CREATE PROCEDURE statement,
-- the MySQL client treats the entire block of code, including all internal semicolons,
-- as a single command until it sees the final //. Once the object is created,
-- the delimiter is reset back to the semicolon.