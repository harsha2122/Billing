-- 1. Create SuperAdmin User
-- Email: superadmin@example.com
-- Password: 12345678

INSERT INTO users (name, email, password, user_type, is_superadmin, status, phone, company_id, warehouse_id, login_enabled, created_at, updated_at)
VALUES (
    'SuperAdmin',
    'superadmin@example.com',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'super_admins',
    1,
    'enabled',
    NULL,
    NULL,
    NULL,
    1,
    NOW(),
    NOW()
);

-- 2. Create Admin User
-- Email: admin@example.com
-- Password: 12345678

INSERT INTO users (name, email, password, user_type, is_superadmin, status, phone, company_id, warehouse_id, login_enabled, created_at, updated_at)
VALUES (
    'Admin',
    'admin@example.com',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'staff_members',
    0,
    'enabled',
    '1234567890',
    1,
    1,
    1,
    NOW(),
    NOW()
);
