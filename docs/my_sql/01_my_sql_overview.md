
## 1. MySQL Server Architecture

MySQL uses a **pluggable storage engine architecture**, meaning the SQL layer (parsing, optimization, execution) is separate from the data storage layer .

### Architecture Layers

| Layer | Function |
|-------|----------|
| **Connection Layer** | Handles client connections, authentication, thread management |
| **SQL Layer** | Parsing, optimization, query execution, caching |
| **Storage Engine Layer** | Actual data storage, retrieval, and indexing |

### Storage Engines (The Heart of MySQL)

MySQL supports multiple storage engines, with **InnoDB** being the default and recommended choice for MySQL 8.4 :

| Engine | Transactions | Locking | Use Case |
|--------|--------------|---------|----------|
| **InnoDB** | Yes (ACID) | Row-level | General purpose, OLTP, foreign keys |
| **MyISAM** | No | Table-level | Read-heavy workloads (legacy) |
| **Memory** | No | Table-level | Temporary data (RAM only) |
| **Archive** | No | Row-level | Historical/audit data |
| **NDB** | Yes | Row-level | High-availability clustering |

**Key InnoDB Features** :
- **ACID compliance**: Atomicity, Consistency, Isolation, Durability
- **MVCC** (Multi-Version Concurrency Control): Allows reads without locking writes
- **Clustered indexes**: Data stored with primary key indexes for fast lookups
- **Foreign key support**: Referential integrity enforcement

---

## 2. MySQL User Management Deep Dive

MySQL implements a **privilege system** that controls exactly what each user can do at multiple levels: global, database, table, column, and routine (stored procedures) .

### User Identity: `username@host`

MySQL identifies users by **both** username and host. `'john'@'localhost'` and `'john'@'%'` are **different users** :

```sql
-- Local access only (same machine)
CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'password';

-- Any host (remote connections allowed)
CREATE USER 'appuser'@'%' IDENTIFIED BY 'password';

-- Specific IP subnet (corporate network)
CREATE USER 'appuser'@'192.168.1.%' IDENTIFIED BY 'password';
```

### Authentication Plugins (MySQL 8.0+)

MySQL 8.4 uses `caching_sha2_password` by default, but you may need `mysql_native_password` for older PHP applications :

| Plugin | Security | Remote | Best For |
|--------|----------|--------|----------|
| `caching_sha2_password` | SHA-256 | Yes | Modern applications (default) |
| `mysql_native_password` | SHA-1 | Yes | Legacy PHP compatibility |
| `auth_socket` | OS-level | No | Local development (Ubuntu/Debian) |

---

## 3. Creating Users & Granting Privileges

### Step 1: Create the User

**Syntax** :
```sql
CREATE USER 'username'@'host' 
  IDENTIFIED BY 'password'
  [PASSWORD EXPIRE INTERVAL 90 DAY];  -- Optional: force password rotation
```

**Practical Examples**:

```sql
-- Basic application user (remote allowed)
CREATE USER 'webapp'@'%' IDENTIFIED BY 'StrongPass123!';

-- Administrator (local only for security)
CREATE USER 'dba'@'localhost' IDENTIFIED BY 'SuperSecure456!';

-- Temporary contractor (password expires in 30 days)
CREATE USER 'contractor'@'%' 
  IDENTIFIED BY 'TempPass789!'
  PASSWORD EXPIRE INTERVAL 30 DAY;
```

### Step 2: Grant Privileges

The **Principle of Least Privilege**: Grant only what is absolutely necessary .

**Privilege Hierarchy**:
```
Global (*.*) > Database (db.*) > Table (db.table) > Column (db.table.col)
```

#### Common Privilege Patterns

**1. Full Application User (Read/Write)** :
```sql
-- Can SELECT, INSERT, UPDATE, DELETE on all tables in 'ecommerce' db only
GRANT SELECT, INSERT, UPDATE, DELETE ON ecommerce.* TO 'webapp'@'%';
```

**2. Read-Only Reporting User** :
```sql
-- Can only read data, perfect for analytics tools
GRANT SELECT ON ecommerce.* TO 'analytics'@'%';
```

**3. Schema Migration User** :
```sql
-- Can modify structure but not necessarily see all data
GRANT CREATE, ALTER, DROP, INDEX, REFERENCES ON ecommerce.* TO 'migrations'@'localhost';
```

**4. Backup User** :
```sql
-- Needs to read everything but can't modify
GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, 
      LOCK TABLES, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';
```

**5. Replication User** :
```sql
-- Minimal privileges for replica servers
GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%';
```

### Dangerous Patterns to Avoid

```sql
-- ❌ NEVER do this for application users!
GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'%' WITH GRANT OPTION;

-- ❌ Avoid wildcards for global privileges
GRANT ALL ON *.* TO 'someone'@'%';
```

The first example creates a **superuser** equivalent to `root`. The `WITH GRANT OPTION` allows that user to grant their privileges to others, effectively creating more admins .

---

## 4. Managing & Auditing Users

### View Current Privileges
```sql
-- Check your own privileges
SHOW GRANTS;

-- Check another user's privileges
SHOW GRANTS FOR 'webapp'@'%';

-- Detailed audit via information_schema
SELECT grantee, table_schema, privilege_type 
FROM information_schema.SCHEMA_PRIVILEGES 
WHERE grantee = "'webapp'@'%'";
```

### Revoke Privileges
```sql
-- Remove specific privileges
REVOKE INSERT, UPDATE ON ecommerce.orders FROM 'analytics'@'%';

-- Revoke all privileges (but keep user)
REVOKE ALL PRIVILEGES ON ecommerce.* FROM 'webapp'@'%';
```

### Modify Users
```sql
-- Change password
ALTER USER 'webapp'@'%' IDENTIFIED BY 'NewSecurePass456!';

-- Change authentication plugin (for PHP compatibility)
ALTER USER 'webapp'@'%' IDENTIFIED WITH mysql_native_password BY 'password';

-- Lock/unlock account
ALTER USER 'webapp'@'%' ACCOUNT LOCK;
ALTER USER 'webapp'@'%' ACCOUNT UNLOCK;
```

### Delete Users
```sql
-- Always specify both username and host
DROP USER 'webapp'@'%';
```

**Important**: In MySQL 8.0+, `DROP USER` automatically revokes privileges first, but in production, always `REVOKE` before `DROP` to ensure a clean audit trail .

---

## 5. Complete Setup Example

Here's a realistic scenario for an e-commerce application:

```sql
-- 1. Create the database
CREATE DATABASE IF NOT EXISTS ecommerce;

-- 2. Create application user (limited to this DB)
CREATE USER 'ecommerce_app'@'%' 
  IDENTIFIED BY 'eCom_2025!Secure';

-- 3. Grant only necessary CRUD operations
GRANT SELECT, INSERT, UPDATE, DELETE 
  ON ecommerce.* 
  TO 'ecommerce_app'@'%';

-- 4. Create read-only user for reporting dashboard
CREATE USER 'ecommerce_ro'@'192.168.1.%' 
  IDENTIFIED BY 'Reports_2025!';

GRANT SELECT ON ecommerce.* TO 'ecommerce_ro'@'192.168.1.%';

-- 5. Create admin user (local only, no remote access)
CREATE USER 'ecommerce_admin'@'localhost' 
  IDENTIFIED BY 'Admin_2025!SuperSecure';

GRANT ALL PRIVILEGES ON ecommerce.* 
  TO 'ecommerce_admin'@'localhost';

-- 6. Verify setup
SHOW GRANTS FOR 'ecommerce_app'@'%';
SHOW GRANTS FOR 'ecommerce_ro'@'192.168.1.%';
```

---

## 6. Best Practices Summary

1. **Never use root for applications**: Create dedicated users for each application/service 
2. **Host restriction**: Use `'user'@'localhost'` for local-only services; use specific IP ranges instead of `'%'` when possible 
3. **Password policies**: Enable password expiration for human users, use strong random passwords for service accounts
4. **Least privilege**: If a user only needs to read data, grant only `SELECT` 
5. **Roles (MySQL 8.0+)**: For teams, create roles instead of individual grants:
   ```sql
   CREATE ROLE 'app_readwrite';
   GRANT SELECT, INSERT, UPDATE, DELETE ON ecommerce.* TO 'app_readwrite';
   GRANT 'app_readwrite' TO 'new_dev'@'localhost';
   ```
   
