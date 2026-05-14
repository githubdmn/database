DROP TABLE IF EXISTS  tbl_string;

CREATE TABLE tbl_string
(
    id        SMALLINT UNSIGNED AUTO_INCREMENT,
    char_fld  CHAR(30),    -- fix-length, blank-padded strings, max 255 characters
    vchar_fld VARCHAR(30), -- variable-length string, up to 65535
    text_fld  TEXT,         -- (tinytext, text, mediumtext, longtext) up to 2GB (4GB...) of text
    PRIMARY KEY (id)
);

INSERT INTO tbl_string(char_fld, vchar_fld, text_fld)
VALUES ('This is fixed-length 30-char',
        'This is variable-length 30-ch',
        'This is a text type, its variatons are tinytext, text, madiumtext, longtext, and they take several GB of text');


UPDATE tbl_string
SET vchar_fld = 'This is too long string, and the operation will respond in error'
-- Data truncation: Data too long for column 'vchar_fld' at row 1
WHERE id = 1;

UPDATE tbl_string
SET vchar_fld = 'This is too long string'
WHERE id = 1;

-- SELECT @@session.sql_mode;
-- SET sql_mode = 'ANSI'
-- SHOW WARNINGS;


-- UPDATE tbl_string
-- SET vchar_fld = 'This doesn\'t work' -- without \ or ' this update wouldn't work
-- WHERE id = 1;

UPDATE tbl_string
SET vchar_fld = 'The UPDATE didn\'t work before'
WHERE id = 1;

-- SELECT 'abcdefg', CHAR(97, 98, 99, 100, 101, 102, 103);
-- SET sql_mode = 'ANSI'
-- SELECT CONCAT('danke sch', CHAR(148), 'n'); -- in order for this to work the line above must be set


