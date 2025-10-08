# SQL Query Clauses - Complete Guide

## Query Execution Order (Logical)
Understanding how SQL processes queries helps write better queries:

```
FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT/OFFSET
```

---

## 1. Core Clauses

### SELECT - Choose Columns
```sql
-- Select specific columns
SELECT first_name, last_name, email FROM users;

-- Select all columns
SELECT * FROM products;

-- Select with expressions
SELECT first_name, last_name, salary * 12 AS annual_salary FROM employees;

-- Select distinct values
SELECT DISTINCT country FROM customers;
```

### FROM - Specify Table(s)
```sql
-- Single table
FROM customers

-- Multiple tables (Cartesian product)
FROM orders, customers

-- With table alias
FROM customers AS c
```

### WHERE - Filter Rows
```sql
-- Comparison operators
WHERE age >= 18
WHERE status = 'active'
WHERE price BETWEEN 100 AND 500

-- Logical operators
WHERE country = 'USA' AND age > 21
WHERE status = 'pending' OR status = 'processing'
WHERE NOT deleted

-- Pattern matching
WHERE email LIKE '%@gmail.com'
WHERE name LIKE 'John%'

-- NULL checks
WHERE phone IS NULL
WHERE address IS NOT NULL

-- IN operator
WHERE country IN ('USA', 'Canada', 'Mexico')

-- Subquery
WHERE customer_id IN (SELECT customer_id FROM vip_customers)
```

---

## 2. Grouping and Aggregation

### GROUP BY - Group Rows
```sql
-- Group by single column
SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country;

-- Group by multiple columns
SELECT country, city, COUNT(*) AS count
FROM customers
GROUP BY country, city;

-- With aggregate functions
SELECT 
    category,
    COUNT(*) AS product_count,
    AVG(price) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    SUM(stock) AS total_stock
FROM products
GROUP BY category;
```

### HAVING - Filter Groups
```sql
-- Filter after grouping
SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country
HAVING COUNT(*) > 50;

-- Multiple conditions
SELECT 
    category,
    AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 100 AND COUNT(*) >= 10;

-- Using aggregate in HAVING
SELECT 
    customer_id,
    SUM(order_total) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(order_total) > 1000
ORDER BY total_spent DESC;
```

**WHERE vs HAVING:**
- `WHERE` filters rows **before** grouping
- `HAVING` filters groups **after** grouping

```sql
-- Correct usage
SELECT category, AVG(price)
FROM products
WHERE in_stock = true        -- Filter rows first
GROUP BY category
HAVING AVG(price) > 50;      -- Filter groups after
```

---

## 3. Sorting and Limiting

### ORDER BY - Sort Results
```sql
-- Single column ascending
SELECT * FROM products ORDER BY price ASC;

-- Single column descending
SELECT * FROM products ORDER BY price DESC;

-- Multiple columns
SELECT * FROM customers 
ORDER BY country ASC, city ASC, last_name ASC;

-- By expression
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary * 12 DESC;

-- By column position (not recommended)
SELECT first_name, last_name, salary
FROM employees
ORDER BY 3 DESC;  -- Orders by 3rd column (salary)

-- NULL handling
ORDER BY email NULLS FIRST
ORDER BY phone NULLS LAST
```

### LIMIT - Restrict Row Count
```sql
-- Top 10 results
SELECT * FROM products ORDER BY price DESC LIMIT 10;

-- MySQL/PostgreSQL syntax
LIMIT 10

-- SQL Server syntax
SELECT TOP 10 * FROM products;

-- Oracle syntax
WHERE ROWNUM <= 10
```

### OFFSET - Skip Rows (Pagination)
```sql
-- Skip first 20 rows, return next 10
SELECT * FROM products 
ORDER BY created_at DESC 
LIMIT 10 OFFSET 20;

-- Page 1 (rows 1-10)
LIMIT 10 OFFSET 0

-- Page 2 (rows 11-20)
LIMIT 10 OFFSET 10

-- Page 3 (rows 21-30)
LIMIT 10 OFFSET 20

-- Generic pagination formula
LIMIT page_size OFFSET (page_number - 1) * page_size
```

---

## 4. JOIN Operations

### INNER JOIN - Matching Rows Only
```sql
SELECT 
    o.order_id,
    c.first_name,
    c.last_name,
    o.order_total
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;
```

### LEFT JOIN - All Left + Matching Right
```sql
-- All customers, even without orders
SELECT 
    c.customer_id,
    c.first_name,
    COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name;
```

### RIGHT JOIN - All Right + Matching Left
```sql
SELECT *
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;
```

### FULL OUTER JOIN - All Rows from Both
```sql
-- PostgreSQL supports this
SELECT *
FROM table1
FULL OUTER JOIN table2 ON table1.id = table2.id;
```

### CROSS JOIN - Cartesian Product
```sql
SELECT *
FROM sizes
CROSS JOIN colors;
```

---

## 5. Subqueries

### Subquery in WHERE
```sql
-- Customers who placed orders
SELECT * FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);

-- Products more expensive than average
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

### Subquery in SELECT
```sql
SELECT 
    customer_id,
    first_name,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.customer_id) AS order_count
FROM customers c;
```

### Subquery in FROM
```sql
SELECT category, avg_price
FROM (
    SELECT category, AVG(price) AS avg_price
    FROM products
    GROUP BY category
) AS category_averages
WHERE avg_price > 100;
```

---

## 6. Advanced Examples

### Complex Query Example
```sql
-- Top 5 customers by total spending in 2023, excluding refunded orders
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_total) AS total_spent,
    AVG(o.order_total) AS avg_order_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_date BETWEEN '2023-01-01' AND '2023-12-31'
    AND o.status != 'refunded'
    AND o.order_total > 0
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(o.order_id) >= 3
ORDER BY total_spent DESC
LIMIT 5;
```

### Window Functions (Advanced)
```sql
-- Rank customers by spending within each country
SELECT 
    customer_id,
    country,
    total_spent,
    RANK() OVER (PARTITION BY country ORDER BY total_spent DESC) AS country_rank
FROM (
    SELECT 
        c.customer_id,
        c.country,
        SUM(o.order_total) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.country
) customer_totals;
```

### Common Table Expressions (CTE)
```sql
-- More readable than subqueries
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count,
        SUM(order_total) AS total_spent
    FROM orders
    GROUP BY customer_id
),
high_value_customers AS (
    SELECT customer_id
    FROM customer_orders
    WHERE total_spent > 1000
)
SELECT 
    c.first_name,
    c.last_name,
    co.order_count,
    co.total_spent
FROM customers c
JOIN customer_orders co ON c.customer_id = co.customer_id
WHERE c.customer_id IN (SELECT customer_id FROM high_value_customers)
ORDER BY co.total_spent DESC;
```

---

## 7. Common Patterns

### Pagination
```sql
-- Page 3, 20 items per page
SELECT * FROM products
ORDER BY product_id
LIMIT 20 OFFSET 40;
```

### Find Duplicates
```sql
SELECT email, COUNT(*) AS count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

### Top N per Group
```sql
-- Top 3 products per category by price
WITH ranked_products AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS rank
    FROM products
)
SELECT * FROM ranked_products
WHERE rank <= 3;
```

### Running Total
```sql
SELECT 
    order_date,
    order_total,
    SUM(order_total) OVER (ORDER BY order_date) AS running_total
FROM orders
ORDER BY order_date;
```

---

## 8. Performance Tips

1. **Index columns used in WHERE, JOIN, and ORDER BY**
2. **Avoid SELECT * in production** - specify only needed columns
3. **Use EXISTS instead of IN** for large subqueries
4. **Limit with WHERE before GROUP BY** when possible
5. **Use EXPLAIN/EXPLAIN ANALYZE** to check query plans
6. **Avoid functions on indexed columns in WHERE** (breaks index usage)

```sql
-- Bad (can't use index on created_at)
WHERE YEAR(created_at) = 2023

-- Good (can use index)
WHERE created_at >= '2023-01-01' AND created_at < '2024-01-01'
```

---

## Quick Reference

| Clause | Purpose | Example |
|--------|---------|---------|
| SELECT | Choose columns | `SELECT name, price` |
| FROM | Specify table | `FROM products` |
| WHERE | Filter rows | `WHERE price > 100` |
| GROUP BY | Group rows | `GROUP BY category` |
| HAVING | Filter groups | `HAVING COUNT(*) > 5` |
| ORDER BY | Sort results | `ORDER BY price DESC` |
| LIMIT | Limit rows | `LIMIT 10` |
| OFFSET | Skip rows | `OFFSET 20` |
| JOIN | Combine tables | `JOIN orders ON ...` |