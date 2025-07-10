`CROSS APPLY` is a **powerful and underused feature in T-SQL**, and it becomes especially useful in *
*modularizing logic**, **handling scalar/multivalued functions**, and **cleanly replacing `CASE` logic with row-level
expansions**.

---

## 🧠 What is `CROSS APPLY`?

`CROSS APPLY` allows you to join each row of an outer (left) table with **a derived table or function** that is
evaluated **per row**.

In simpler terms:

* Think of `CROSS APPLY` as a **row-by-row JOIN** to a **subquery or expression that depends on the current row**.
* It works like a **correlated subquery**, but returns **tabular** results, not scalar.
* Very useful with:

    * Table-valued functions
    * Row generators (`VALUES(...)`)
    * Top-N filtering or ranking (ROW\_NUMBER, etc.)

---

## 🧬 Syntax & Behavior

```sql
SELECT...
    FROM OuterTable ot
    CROSS APPLY (
    SELECT...
    FROM SomeDerivedTable sdt
    WHERE sdt.col = ot.col
    ) derived
```

For each row of `OuterTable`, `derived` is evaluated **as if it were a correlated subquery** — producing **0, 1, or many
rows**, and joining them to the outer row.

---

## 🧮 Example: Replacing Multiple `CASE` with `CROSS APPLY`

Let's say you want to output multiple "flags" or classifications for a person, based on their status:

### ❌ Without `CROSS APPLY` (duplicated CASE):

```sql
SELECT id,
       CASE WHEN age >= 65 THEN 'Senior' END          AS classification1,
       CASE WHEN income < 20000 THEN 'Low Income' END AS classification2,
       CASE WHEN is_student = 1 THEN 'Student' END    AS classification3
FROM people
```

This gives **one row per person**, with multiple columns — but if you want **a separate row per classification**, you
have to rewrite it.

---

### ✅ With `CROSS APPLY` (clean row expansion):

```sql
SELECT p.id,
       flags.label
FROM people p
    CROSS APPLY (
    VALUES
        ('Senior',      IIF(p.age >= 65, 1, 0)),
        ('Low Income',  IIF(p.income < 20000, 1, 0)),
        ('Student',     IIF(p.is_student = 1, 1, 0))
) flags(label, is_active)
WHERE flags.is_active = 1;
```

Now you get:

| id | label      |
|----|------------|
| 1  | Senior     |
| 1  | Low Income |
| 2  | Student    |
| 3  | Low Income |

Each relevant **classification** is shown as a separate row — this is powerful for reporting.

---

## 🔄 `CROSS APPLY` vs `OUTER APPLY`

| Feature                                 | CROSS APPLY                | OUTER APPLY                  |
|-----------------------------------------|----------------------------|------------------------------|
| Filters rows if APPLY returns no result | Yes                        | No (returns NULLs)           |
| Equivalent to                           | INNER JOIN (row-by-row)    | LEFT JOIN (row-by-row)       |
| Use when                                | You only want matched rows | You also want unmatched rows |

---

## 🛠 Practical Use Cases

| Use Case                         | Example                               |
|----------------------------------|---------------------------------------|
| Top 1 per group                  | `CROSS APPLY (SELECT TOP 1 ...)`      |
| Multi-condition flags            | `VALUES (...)` + `IIF(...)`           |
| Table-valued function per row    | `CROSS APPLY dbo.GetSomething(p.id)`  |
| JSON/XML parsing row-by-row      | `CROSS APPLY OPENJSON(...)`           |
| Filtering inline subquery output | See current `Late Collection` example |

---

## ✅ Summary

* `CROSS APPLY` is great for **row-wise derived tables**.
* It simplifies **complex conditional logic**.
* It behaves like a `JOIN`, but is more powerful with inline logic.
* Paired with `VALUES(...)`, it becomes a concise **multi-row generator** per input.

