
-- TEMPORAL DATA
SELECT @@global.time_zone, @@session.time_zone;
-- SET time_zone = 'Europe/Zurich'; -- ORACLE -> ALTER SESSION TIMEZONE = 'Europe/Zurich';
--
SELECT CAST('2008-09-17 15:30:00' AS DATETIME);
--
SELECT
  CAST('2008-09-17' AS DATE) AS  date_field,
  CAST('15:30:21' AS TIME) AS time_field;
--
SELECT STR_TO_DATE('September 17, 2008', '%M %d, %Y');
--
SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP(); 


