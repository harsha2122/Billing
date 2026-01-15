-- Delete existing admin/superadmin users
DELETE FROM users WHERE email IN ('admin@example.com', 'superadmin@example.com');

-- Now run: php artisan db:seed --class=AdminUsersSeeder
