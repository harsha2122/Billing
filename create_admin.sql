-- First, check existing users
SELECT id, name, email, user_type, is_superadmin FROM users;

-- Delete existing admin if needed (optional)
-- DELETE FROM users WHERE email = 'admin@example.com';

-- Create new admin user
-- Password: 12345678 (already bcrypt hashed)
INSERT INTO users (name, email, password, user_type, is_superadmin, status, phone, company_id, warehouse_id, created_at, updated_at)
VALUES (
    'Admin',
    'admin@example.com',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: 12345678
    'staff_members',
    0,
    'enabled',
    '1234567890',
    1,
    1,
    NOW(),
    NOW()
);

-- Update existing admin user (alternative to INSERT)
UPDATE users
SET password = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    user_type = 'staff_members',
    is_superadmin = 0,
    company_id = 1,
    warehouse_id = 1
WHERE email = 'admin@example.com';

-- Update superadmin user_type
UPDATE users
SET user_type = 'super_admins'
WHERE email = 'superadmin@example.com' OR is_superadmin = 1;
