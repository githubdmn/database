SELECT
    a.account_id,
    e.emp_id,
    b_a.name AS open_branch,
    b_e.name AS emp_branch
FROM account AS a
    INNER JOIN branch AS b_a
    ON a.open_branch_id = b_a.branch_id
    INNER JOIN employee AS e
            ON a.open_emp_id = e.emp_id
    INNER JOIN branch AS b_e
        ON e.assigned_branch_id = b_e.branch_id
WHERE a.product_cd = 'CHK';