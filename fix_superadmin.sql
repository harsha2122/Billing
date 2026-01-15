-- Run this SQL to fix existing superadmin user
UPDATE users
SET user_type = 'super_admins'
WHERE email = 'superadmin@example.com' AND is_superadmin = 1;
