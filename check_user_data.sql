-- Check admin user has all required data
SELECT
    id,
    name,
    email,
    user_type,
    is_superadmin,
    role_id,
    company_id,
    warehouse_id,
    status,
    login_enabled
FROM users
WHERE email IN ('admin@example.com', 'superadmin@example.com');

-- Check if role exists
SELECT id, company_id, name, display_name FROM roles;

-- Check if warehouse exists
SELECT id, company_id, name FROM warehouses;

-- Check if company has required fields
SELECT
    id,
    name,
    currency_id,
    warehouse_id,
    lang_id
FROM companies;
