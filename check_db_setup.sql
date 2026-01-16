-- Check database setup
SELECT 'Companies' as table_name, COUNT(*) as count FROM companies;
SELECT 'Warehouses' as table_name, COUNT(*) as count FROM warehouses;
SELECT 'Users' as table_name, COUNT(*) as count FROM users;
SELECT 'Currencies' as table_name, COUNT(*) as count FROM currencies;

-- Check company configuration
SELECT id, name, currency_id, warehouse_id, 'x_currency_id and x_warehouse_id must not be NULL' as note
FROM companies;

-- Check admin users
SELECT id, email, user_type, is_superadmin, role_id, warehouse_id, company_id, 'role_id, warehouse_id, company_id must not be NULL' as note
FROM users
WHERE email IN ('admin@example.com', 'superadmin@example.com');
