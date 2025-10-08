

CREATE TABLE auth_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE, -- COLLATE utf8mb4_unicode_ci,
    email_verified_at TIMESTAMP NULL,
    display_name VARCHAR(255),
    avatar_url VARCHAR(255),
    locale VARCHAR(10) DEFAULT 'en',
    timezone VARCHAR(50) DEFAULT 'UTC',
    status ENUM('active', 'suspended', 'deactivated') NOT NULL DEFAULT 'active',
    deactivated_at TIMESTAMP NULL,
    deactivated_by INT NULL,
    deactivated_reason VARCHAR(255) NULL,
    last_login_at TIMESTAMP NULL,
    login_count INT DEFAULT 0,
    failed_login_count INT DEFAULT 0,
    locked_until TIMESTAMP NULL,
    password_changed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (deactivated_by) REFERENCES auth_user(id) ON DELETE SET NULL
);

CREATE UNIQUE INDEX idx_auth_user_user_id ON auth_user(user_id);
CREATE UNIQUE INDEX idx_auth_user_email ON auth_user(email);
CREATE INDEX idx_auth_user_status ON auth_user(status);
-- Partial index not supported in MySQL:
-- CREATE INDEX idx_auth_user_deactivation ON auth_user(status, deactivated_at);

-- # CREATE INDEX vs CREATE UNIQUE INDEX

