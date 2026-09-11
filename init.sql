-- ============================================================
-- User Management Database — Schema and Seed Data
-- Runs automatically on first container startup
-- ============================================================

-- ============================================================
-- 1. DATABASE
-- ============================================================
CREATE DATABASE IF NOT EXISTS user_management_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE user_management_db;

-- ============================================================
-- 2. APP USER (for backend connection)
-- ============================================================
-- Note: MYSQL_USER env var already creates 'userapp', but we
-- create it here too in case the env var isn't picked up
CREATE USER IF NOT EXISTS 'userapp'@'%' IDENTIFIED BY 'userapp123';
GRANT ALL PRIVILEGES ON user_management_db.* TO 'userapp'@'%';

-- Also allow root to connect from any host
ALTER USER 'root'@'%' IDENTIFIED BY 'rootpass123';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

-- ============================================================
-- 3. USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    phone       VARCHAR(50),
    role        VARCHAR(20)  NOT NULL DEFAULT 'USER',
    status      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_email  (email),
    INDEX idx_role   (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. SEED DATA
-- ============================================================
-- Use INSERT IGNORE so it's safe to re-run
INSERT IGNORE INTO users (id, first_name, last_name, email, phone, role, status) VALUES
    (1, 'Rahul',  'Sharma', 'rahul@example.com',  '9876543210', 'ADMIN',   'ACTIVE'),
    (2, 'Priya',  'Patel',  'priya@example.com',  '9876500000', 'USER',    'ACTIVE'),
    (3, 'Amit',   'Verma',  'amit@example.com',   '9876511111', 'MANAGER', 'INACTIVE'),
    (4, 'Sneha',  'Reddy',  'sneha@example.com',  '9876522222', 'USER',    'ACTIVE'),
    (5, 'Vikram', 'Singh',  'vikram@example.com', '9876533333', 'ADMIN',   'ACTIVE');

-- ============================================================
-- 5. VERIFICATION (shows in Docker logs)
-- ============================================================
SELECT '✅ user_management_db initialized' AS status;
SELECT CONCAT('📊 Users seeded: ', COUNT(*)) AS count FROM users;
SELECT CONCAT('👥 Admin users: ', COUNT(*)) AS admins FROM users WHERE role = 'ADMIN';
SELECT CONCAT('✅ Active users: ', COUNT(*)) AS active FROM users WHERE status = 'ACTIVE';
