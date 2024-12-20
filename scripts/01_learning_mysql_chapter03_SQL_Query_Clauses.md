**SQL Query Clauses**

SQL queries are constructed using various clauses to retrieve specific data from a database. 

**Core Clauses**

1. **SELECT:**
   - Specifies the columns to retrieve from the table.
   - Syntax: `SELECT column1, column2, ... FROM table_name;`

2. **FROM:**
   - Indicates the table(s) to query.
   - Syntax: `FROM table_name;`

3. **WHERE:**
   - Filters the rows based on a specified condition.
   - Syntax: `WHERE condition;`

**Example:**

```sql
SELECT * FROM customers WHERE country = 'USA';
```

**Additional Clauses**

1. **GROUP BY:**
   - Groups rows based on one or more columns.
   - Often used with aggregate functions like `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`.
   - Syntax: `GROUP BY column1, column2, ...;`

2. **HAVING:**
   - Filters the groups created by the `GROUP BY` clause.
   - Syntax: `HAVING condition;`

3. **ORDER BY:**
   - Sorts the result set in ascending or descending order.
   - Syntax: `ORDER BY column1 ASC|DESC, column2 ASC|DESC, ...;`

4. **LIMIT:**
   - Limits the number of rows returned by the query.
   - Syntax: `LIMIT number;`

5. **OFFSET:**
   - Skips a specified number of rows before returning the result set.
   - Syntax: `OFFSET number;`

**Example:**

```sql
SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country
HAVING COUNT(*) > 100
ORDER BY customer_count DESC
LIMIT 5;
```

**Combining Clauses**

You can combine these clauses to create complex queries. For instance:

```sql
SELECT customer_id, first_name, last_name, order_total
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY customer_id
HAVING SUM(order_total) > 1000
ORDER BY order_total DESC;
```

**Key Points to Remember**

- **Order of Clauses:** Typically, the order of clauses is: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`, and `OFFSET`.
- **Aggregate Functions:** Use `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX` to perform calculations on groups of rows.
- **Subqueries:** You can nest queries within other queries to create complex data retrieval operations.
- **JOINs:** Combine rows from two or more tables based on a related column. Common types of JOINs include `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL OUTER JOIN`.

By mastering these clauses and their combinations, you can extract valuable insights from your database.

**Would you like to explore specific use cases or dive deeper into a particular clause?**
