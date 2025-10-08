CREATE TABLE auth_tenant (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id          VARCHAR(36) NOT NULL UNIQUE,
    tenant_code        VARCHAR(63) NOT NULL UNIQUE,
    name               VARCHAR(255) NOT NULL,
    display_name       VARCHAR(255),
    description        TEXT,
    logo_url           VARCHAR(500),
    website_url        VARCHAR(500),
    contact_email      VARCHAR(255),
    billing_email      VARCHAR(255),
    
    -- Status & subscription
    status             ENUM('pending', 'active', 'trial', 'suspended', 'archived') 
                       NOT NULL DEFAULT 'pending',
    plan               ENUM('free', 'trial', 'basic', 'pro', 'enterprise', 'custom') 
                       NOT NULL DEFAULT 'free',
    subscription_id    VARCHAR(100),
    trial_ends_at      TIMESTAMP NULL,
    
    -- Limits
    max_users          INT DEFAULT 10,
    max_storage_mb     INT DEFAULT 1024,
    
    -- Configuration (native JSON)
    features           JSON,
    settings           JSON,
    
    -- Ownership
    owner_id           INT,
    billing_contact_id INT,
    
    -- Activity & timestamps
    last_activity_at   TIMESTAMP NULL,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Soft delete
    deleted_at         TIMESTAMP NULL,
    deleted_by         INT,
    
    FOREIGN KEY (owner_id) REFERENCES auth_user(id) ON DELETE RESTRICT,
    FOREIGN KEY (billing_contact_id) REFERENCES auth_user(id) ON DELETE SET NULL,
    FOREIGN KEY (deleted_by) REFERENCES auth_user(id) ON DELETE SET NULL,
    
    -- Validation (MySQL 8.0.16+)
    CHECK (CHAR_LENGTH(tenant_code) >= 3 AND CHAR_LENGTH(tenant_code) <= 63),
    CHECK (tenant_code = LOWER(tenant_code)),
    CHECK (tenant_code REGEXP '^[a-z0-9-]+$'),
    CHECK (tenant_code NOT LIKE '--%'),
    CHECK (tenant_code NOT LIKE '-%' AND tenant_code NOT LIKE '%-')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Indexes
CREATE UNIQUE INDEX idx_auth_tenant_tenant_id ON auth_tenant(tenant_id);
CREATE UNIQUE INDEX idx_auth_tenant_code ON auth_tenant(tenant_code);
CREATE INDEX idx_auth_tenant_status ON auth_tenant(status);
CREATE INDEX idx_auth_tenant_owner ON auth_tenant(owner_id);
CREATE INDEX idx_auth_tenant_activity ON auth_tenant(last_activity_at);
CREATE INDEX idx_auth_tenant_deleted ON auth_tenant(deleted_at);
CREATE INDEX idx_auth_tenant_trial_expiry ON auth_tenant(trial_ends_at, status);
