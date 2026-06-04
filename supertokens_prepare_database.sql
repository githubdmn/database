-- =====================================================================
-- SUPERTOKENS ISOLATED DATABASE INITIALIZATION SCRIPT
-- Execute this as a superuser (e.g., 'app_user' or 'postgres')
-- Connected to the 'general' database
-- =====================================================================

-- 1. Create the dedicated Supertokens service user
-- (Skip this if the user already exists, or run it fresh)
CREATE USER supertoken_user WITH PASSWORD 'supertoken_password';

-- 2. Explicitly grant connection rights to the main database
GRANT CONNECT ON DATABASE general TO supertoken_user;

-- 3. Create the dedicated schema and assign ownership
-- This ensures Supertokens tables don't clutter the 'public' schema
CREATE SCHEMA IF NOT EXISTS supertokens_schema AUTHORIZATION supertoken_user;

-- 4. Apply strict, granular privilege rules
-- Ensure the user owns the schema entirely
ALTER SCHEMA supertokens_schema OWNER TO supertoken_user;

-- Grant all permissions inside this specific sandbox
GRANT ALL PRIVILEGES ON SCHEMA supertokens_schema TO supertoken_user;

-- 5. Safety Net: Ensure future tables automatically inherit full permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA supertokens_schema 
GRANT ALL ON TABLES TO supertoken_user;
