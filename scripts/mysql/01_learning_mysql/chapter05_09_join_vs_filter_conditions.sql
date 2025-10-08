-- compare the following statements (a, b and c)
--
-- a) filter in WHERE after the JOIN
SELECT a.account_id,
       a.product_cd,
       c.fed_id
FROM account AS a
         INNER JOIN customer as c
                    ON a.cust_id = c.cust_id
WHERE c.cust_type_cd = 'B';

-- b) filter placed in the JOIN ... ON clause
SELECT a.account_id,
       a.product_cd,
       c.fed_id
FROM account AS a
         INNER JOIN customer as c
                    ON a.cust_id = c.cust_id
                        AND c.cust_type_cd = 'B';

-- c) old/ANSI-89 style: join condition and filter in WHERE
SELECT a.account_id,
       a.product_cd,
       c.fed_id
FROM account AS a
         INNER JOIN customer as c
WHERE a.cust_id = c.cust_id
  AND c.cust_type_cd = 'B';

-- Explanation:
-- For INNER JOINs, (a), (b), and (c) are logically equivalent: they all return the same rows
-- because c.cust_type_cd = 'B' is a regular filter (null-rejecting) on the joined customer rows.
--
-- a) puts the predicate in WHERE, after the join is formed.
-- b) pushes the same predicate into the ON clause. For INNER JOIN, the optimizer can (and typically does)
--    treat it the same as a WHERE filter; plans and results are usually identical. Some prefer (b) to make
--    it explicit that the filter relates to the joined table, which may aid readability and index usage is unaffected.
-- c) expresses the join using a WHERE equality predicate (ANSI-89 style). With INNER JOINs this is still equivalent
--    but is generally discouraged in favor of explicit JOIN ... ON syntax for clarity, especially when multiple joins exist.
--
-- Important caveat (not shown here): with OUTER JOINs the placement matters.
-- - Putting additional filters on the OUTER-joined table in WHERE can turn an OUTER JOIN into an effective INNER JOIN
--   by eliminating NULL-augmented rows.
-- - Keeping such predicates in the ON clause preserves the OUTER JOIN semantics.
--
-- Summary: For these INNER JOIN examples, all three yield the same result set; the differences are stylistic/readability.
-- For OUTER JOINs, predicate placement (ON vs WHERE) changes results and must be chosen carefully.