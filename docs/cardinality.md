# **Cardinality in SQL: A Complete Guide**

Cardinality in SQL refers to the **uniqueness of values** in a database column. It indicates how many distinct values
exist in a column relative to the total number of rows. Understanding cardinality is crucial for database optimization,
indexing strategies, and query performance.

---

## **Types of Cardinality**

### **1. High Cardinality**

- **Definition**: A column with many unique values (close to the total row count).
- **Examples**:
    - `user_id` (each row has a unique ID)
    - `email` (most emails are unique)
    - `transaction_id` (rarely duplicated)
- **Indexing Benefit**:  
  ✔ Excellent for B-tree indexes (fast lookups).  
  ✔ Works well for `WHERE`, `JOIN`, and `ORDER BY` clauses.

### **2. Low Cardinality**

- **Definition**: A column with very few unique values (heavily duplicated).
- **Examples**:
    - `gender` (Male/Female/Other)
    - `status` (Active/Inactive/Pending)
    - `boolean_flags` (True/False)
- **Indexing Consideration**:  
  ❌ Single-column indexes are often **ineffective** (query optimizer may ignore them).  
  ✔ Works better in **composite indexes** or **bitmap indexes** (Oracle, data warehouses).

### **3. Normal Cardinality**

- **Definition**: A moderate number of unique values (neither too high nor too low).
- **Examples**:
    - `country` (100+ distinct values)
    - `product_category` (50-200 unique categories)
- **Indexing Benefit**:  
  ✔ Good for indexing if frequently queried.  
  ✔ Works well in `WHERE` and `GROUP BY` operations.

---

## **Why Does Cardinality Matter in SQL?**

### **1. Query Performance**

- **High-cardinality columns** → Efficient for precise lookups (`WHERE user_id = 100`).
- **Low-cardinality columns** → Often lead to **full table scans** (slow performance).

### **2. Indexing Strategy**

- **B-tree indexes** (default in MySQL, PostgreSQL, SQL Server) work best on **high-cardinality** columns.
- **Bitmap indexes** (Oracle, data warehouses) are optimized for **low-cardinality** columns.

### **3. Join Operations**

- High-cardinality columns (like `PRIMARY KEY`) make joins faster.
- Low-cardinality columns in joins can cause performance bottlenecks.

### **4. Database Statistics**

- SQL optimizers use cardinality to **estimate query costs**.
- Outdated statistics can lead to **bad execution plans**.

---

## **How to Check Cardinality in SQL**

### **1. Using `COUNT(DISTINCT)`**

```sql
SELECT COUNT(*)                    AS total_rows,
       COUNT(DISTINCT column_name) AS distinct_values,
       (COUNT(DISTINCT column_name) * 100.0 / COUNT(*) AS uniqueness_percentage
FROM table_name;
```

**Example**:

```sql
-- Check cardinality of "gender" in a users table
SELECT COUNT(*)                                    AS total_users,
       COUNT(DISTINCT gender)                      AS unique_genders,
       (COUNT(DISTINCT gender) * 100.0 / COUNT(*)) AS uniqueness_pct
FROM users;
```

**Output**:
| total_users | unique_genders | uniqueness_pct |
|-------------|----------------|----------------|
| 10,000 | 3 | 0.03% | → **Low cardinality**

### **2. Using Database Metadata (SQL Server)**

```sql
SELECT t.name                              AS table_name,
       c.name                              AS column_name,
       STATS_DATE(c.object_id, c.stats_id) AS stats_last_updated,
       s.rows                              AS total_rows,
       s.distinct_values
FROM sys.stats AS s
         JOIN sys.tables AS t ON s.object_id = t.object_id
         JOIN sys.columns AS c ON t.object_id = c.object_id
WHERE t.name = 'your_table';
```

---

## **Best Practices for Cardinality & Indexing**

| **Scenario**                  | **Recommended Action**                                                                                                                               |
|-------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| **High-cardinality column**   | ✔ Use B-tree index (great for `WHERE`, `JOIN`).                                                                                                      |
| **Low-cardinality column**    | ❌ Avoid single-column index (useless for filtering).<br>✔ Use in **composite indexes** (`status + date`).<br>✔ Consider **bitmap indexes** (Oracle). |
| **Normal-cardinality column** | ✔ Index if frequently queried.                                                                                                                       |
| **Composite index needed**    | ✔ Put **high-cardinality columns first** (`user_id + status`).                                                                                       |

### **Example of a Good Composite Index**

```sql
-- Better than indexing "status" alone (low cardinality)
CREATE INDEX idx_status_created ON orders (status, created_at);
```

- **Why?**  
  ✔ `status` alone is ineffective (too many duplicates).  
  ✔ But `status + created_at` helps narrow down queries efficiently.

---

## **Conclusion**

- **High cardinality** = Many unique values → **Great for indexing**.
- **Low cardinality** = Few unique values → **Avoid single-column indexes**.
- **Normal cardinality** = Moderate uniqueness → **Index if frequently filtered**.

**Key Takeaway**: Always analyze cardinality before creating indexes to optimize query performance! 🚀