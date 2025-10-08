
CREATE VIEW condition5_vw AS
  SELECT 
    product_cd
  FROM 
    product
  WHERE 
    product_type_cd = 'ACCOUNT';
    
SELECT * FROM condition5_vw;

SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE product_cd IN (SELECT product_cd FROM condition5_vw);

