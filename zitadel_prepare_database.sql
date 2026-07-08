-- =====================================================================
-- ZITADEL ISOLATED DATABASE INITIALIZATION SCRIPT
-- Execute this as a superuser (e.g., 'app_user' or 'postgres')
-- =====================================================================

-- 1. Create the dedicated Zitadel service user (if not exists)
-- DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_user WHERE usename = 'zitadel_user') THEN
CREATE USER zitadel_user WITH PASSWORD 'zitadel_password';
END IF;
END
-- $$;

-- 2. Create the dedicated database (if not exists)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'zitadel') THEN
CREATE DATABASE zitadel;
END IF;
END
$$;

-- 3. Grant connection rights
GRANT CONNECT ON DATABASE zitadel TO zitadel_user;

-- 4. Connect to the zitadel database to create the schema
-- (Run this separately - you can't switch databases in a single script)
\c zitadel

-- 5. Create the dedicated schema
CREATE SCHEMA IF NOT EXISTS zitadel_schema;

-- 6. Grant schema permissions to zitadel_user
GRANT USAGE ON SCHEMA zitadel_schema TO zitadel_user;
GRANT CREATE ON SCHEMA zitadel_schema TO zitadel_user;

-- 7. Grant all privileges on the schema
GRANT ALL PRIVILEGES ON SCHEMA zitadel_schema TO zitadel_user;

-- 8. Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA zitadel_schema
GRANT ALL ON TABLES TO zitadel_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA zitadel_schema
GRANT ALL ON SEQUENCES TO zitadel_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA zitadel_schema
GRANT ALL ON FUNCTIONS TO zitadel_user;

-- 9. Make zitadel_user the owner of the schema
ALTER SCHEMA zitadel_schema OWNER TO zitadel_user;

-- 10. Update the search path for zitadel_user
ALTER USER zitadel_user SET search_path TO zitadel_schema, public;

-- 11. Grant all privileges on the database
GRANT ALL PRIVILEGES ON DATABASE zitadel TO zitadel_user;

-- 12. Grant membership to the user
GRANT zitadel_user TO app_user;

-- 13. Verify setup
SELECT
    schema_name,
    schema_owner
FROM information_schema.schemata
WHERE schema_name = 'zitadel_schema';