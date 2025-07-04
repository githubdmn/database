
### **Clustered Index**

1. **Physical Order**
    - Determines how data is **physically stored** on disk.
    - The table is **sorted** by the clustered index key.

2. **One Per Table**
    - Only **one** clustered index allowed per table (since data can’t be physically sorted in multiple ways).

3. **Primary Key Default**
    - In most DBMS (SQL Server, MySQL/InnoDB), the PRIMARY KEY automatically becomes the clustered index unless
      specified otherwise.

4. **Performance**
    - Faster for **range queries** (e.g., `WHERE date BETWEEN '2023-01-01' AND '2023-12-31'`) because data is stored
      contiguously.

5. **Storage**
    - Does **not** require extra storage (the index *is* the table structure).

6. **Example**
   ```sql
   CREATE CLUSTERED INDEX IX_Orders_OrderDate ON Orders(OrderDate);
   ```

---

### **Non-Clustered Index (No Cluster)**

1. **Logical Order**
    - Creates a **separate structure** that points to the actual data (like a "table of contents").
    - Does **not** affect physical storage.

2. **Multiple Allowed**
    - You can have **many** non-clustered indexes per table (SQL Server allows 999, MySQL/InnoDB allows 64).

3. **Slower for Data Retrieval**
    - Requires **two steps**:
        1. Look up the index.
        2. Fetch the actual data from the table (unless the index is "covering").

4. **Extra Storage**
    - Consumes additional space to store the index structure.

5. **Example**
   ```sql
   CREATE NONCLUSTERED INDEX IX_Customers_LastName ON Customers(LastName);
   ```

---

### **Key Differences Summary**

| Feature              | Clustered Index             | Non-Clustered Index                |
|----------------------|-----------------------------|------------------------------------|
| **Number per table** | 1                           | Multiple (e.g., 999 in SQL Server) |
| **Physical sorting** | Yes (data is reordered)     | No (separate structure)            |
| **Storage overhead** | None (data is the index)    | Extra space required               |
| **Best for**         | Range queries, primary keys | Columns in WHERE/JOIN/ORDER BY     |
| **Lookup speed**     | Direct access (faster)      | Indirect (slower, unless covering) |
| **Default for PK**   | Yes (usually)               | No                                 |

---

### **When to Use Each**

- **Use a clustered index for**:
    - Columns frequently used in **range scans** (e.g., dates, auto-increment IDs).
    - PRIMARY KEY (if queries benefit from physical ordering).

- **Use a non-clustered index for**:
    - Columns often filtered in `WHERE` clauses (e.g., `last_name`, `email`).
    - FOREIGN KEY columns used in JOINs.
    - Columns in `ORDER BY` or `GROUP BY`.

---

### **Real-World Example**

```sql
-- Clustered index (physically sorts the table by OrderID)
CREATE
CLUSTERED INDEX IX_Orders_OrderID ON Orders(OrderID);

-- Non-clustered index (speeds up searches by CustomerID)
CREATE
NONCLUSTERED INDEX IX_Orders_CustomerID ON Orders(CustomerID);
```

**Why?**

- `OrderID` is unique and often queried sequentially (e.g., recent orders).
- `CustomerID` is used in JOINs and WHERE clauses but doesn’t need physical sorting.

---

### **Performance Tip**

- A **covering index** (includes all columns needed by a query) avoids the "key lookup" penalty:
  ```sql
  CREATE NONCLUSTERED INDEX IX_Covering ON Orders(CustomerID) INCLUDE (OrderDate, TotalAmount);
  -- Query: SELECT OrderDate, TotalAmount FROM Orders WHERE CustomerID = 100;
  ```