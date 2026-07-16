-- GROUP BY with ROLLUP (Adding Subtotals)
    -- This adds extra rows with NULL in the grouped columns showing subtotals.
-- WITH ROLLUP adds summary rows for each group:
SELECT
    product_cd,
    open_branch_id,
    SUM(avail_balance) AS total_balance
FROM account
GROUP BY product_cd, open_branch_id WITH ROLLUP;