CREATE TABLE auth_credential (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    
    type            VARCHAR(50) NOT NULL,
    identifier      VARCHAR(255),
    
    secret_hash     TEXT NOT NULL,
    
    algorithm       VARCHAR(20) DEFAULT 'argon2id',
    iterations      INT,
    memory_cost     INT,
    parallelism     INT,
    
    status          ENUM('active', 'expired', 'revoked', 'reset_pending', 'used') 
                    DEFAULT 'active',
    expires_at      TIMESTAMP NULL,
    
    last_used_at    TIMESTAMP NULL,
    use_count       INT DEFAULT 0,
    max_uses        INT,
    
    ip_restrictions JSON,
    scope           TEXT,
    
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES auth_user(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_type_identifier (user_id, type, identifier),
    
    CHECK (type IN ('password', 'api_key', 'recovery_code', 'magic_link', 'totp_backup')),
    CHECK (algorithm IN ('argon2id', 'argon2i', 'bcrypt', 'scrypt')),
    CHECK (max_uses IS NULL OR use_count <= max_uses)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_auth_credential_user_id ON auth_credential(user_id);
CREATE INDEX idx_auth_credential_type ON auth_credential(type);
CREATE INDEX idx_auth_credential_status ON auth_credential(status);
CREATE INDEX idx_auth_credential_user_type_status ON auth_credential(user_id, type, status);
CREATE INDEX idx_auth_credential_expires ON auth_credential(expires_at);
