INSERT INTO tbl_string (char_fld, vchar_fld, text_fld)
VALUES ('This string is 28 characters',
        'This string is 28 characters',
        'This string is 28 characters');


SELECT LENGTH(char_fld)  AS char_length,
       LENGTH(vchar_fld) AS varchar_lenght,
       LENGTH(text_fld)  AS text_length
FROM tbl_string
WHERE id = 2;

SELECT POSITION('character' IN vchar_fld)
FROM tbl_string
WHERE id = 2;

SELECT LOCATE('is', vchar_fld, 5)
FROM tbl_string
WHERE id = 2;

INSERT INTO tbl_string (vchar_fld)
VALUES ('abcd');

INSERT INTO tbl_string (vchar_fld)
VALUES ('xyz');

INSERT INTO tbl_string (vchar_fld)
VALUES ('QRSTUV');

INSERT INTO tbl_string (vchar_fld)
VALUES ('qrstuv');

INSERT INTO tbl_string (vchar_fld)
VALUES ('12345');

SELECT STRCMP('12345', '12345')   AS 12345_12345,
       STRCMP('abcd', 'xyz')      AS abcd_xyz,
       STRCMP('abcd', '12345')    AS abcd_12345,
       STRCMP('qrstuv', 'QRSTUV') AS qrstuv_QRSTUV,
       STRCMP('12345', 'QRSTUV')  AS 12345_QRSTUV,
       STRCMP('xyz', 'qrstuv')    AS xyz_qrstuv;

SELECT name, name LIKE '%ns' AS ends_in_ns
FROM department;

SELECT cust_id,
       cust_type_cd,
       fed_id,
       fed_id REGEXP '.{3}-.{2}-.{4}' AS is_ss_no_formant
FROM customer;

INSERT INTO tbl_string (text_fld)
VALUES ('This string was 29 characters');

UPDATE tbl_string
SET text_fld = CONCAT(text_fld, ', but now it is longer');

SELECT CONCAT(fname, ' ', lname, ' has been a ', title, ' since ', start_date) AS emp_narravtive
FROM employee
WHERE title = 'Teller'
   OR title = 'Head Teller';

SELECT INSERT ('Hello everyone', 7, 0, 'to ' ) AS altered_string;
SELECT INSERT ('Hello everyone', 12, 7, 'body ' ) AS altered_string;

