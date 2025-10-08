CREATE TABLE auth_user_provider
(
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    user_id                 INT          NOT NULL,

    -- Provider identity
    provider                VARCHAR(50)  NOT NULL,
    provider_user_id        VARCHAR(255) NOT NULL,

    -- Provider profile data
    provider_email          VARCHAR(255) NULL,
    provider_email_verified TINYINT(1) DEFAULT 0,
    provider_data           JSON, -- Native JSON type in MySQL 5.7+

    -- Optional: Only if you need API access on behalf of user
    -- refresh_token_encrypted TEXT,
    -- token_expires_at        TIMESTAMP NULL,
    -- encryption_key_id       VARCHAR(100),

    -- Metadata
    is_primary              TINYINT(1) DEFAULT 0,
    last_used_at            TIMESTAMP    NULL,
    created_at              TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES auth_user (id) ON DELETE CASCADE,
    UNIQUE KEY unique_provider_user (provider, provider_user_id),

    -- Optional: Enforce known providers at DB level
    CHECK (provider IN ('google', 'github', 'microsoft', 'facebook', 'apple',
                        'okta', 'auth0', 'gitlab', 'linkedin', 'twitter'))
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- Indexes
CREATE INDEX idx_auth_user_provider_user
    ON auth_user_provider (user_id);

CREATE INDEX idx_auth_user_provider_lookup
    ON auth_user_provider (provider, provider_user_id);

CREATE INDEX idx_auth_user_provider_email
    ON auth_user_provider (provider_email);

CREATE INDEX idx_auth_user_provider_primary
    ON auth_user_provider (user_id, is_primary);

CREATE INDEX idx_auth_user_provider_last_used
    ON auth_user_provider (last_used_at);